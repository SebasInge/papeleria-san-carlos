// Catálogo de productos. Deliberadamente nunca se selecciona ni se acepta
// precio ni stock: esos campos no existen en la tabla `productos` (RF-03, RF-04).
const pool = require("../config/db");

// Público: catálogo completo, opcionalmente filtrado por categoría (RF-01, RF-07).
// El filtro incluye la categoría pedida y toda su rama descendiente usando
// una CTE recursiva, para que un producto asignado a una subcategoría
// también aparezca al navegar su categoría padre (herencia).
// Devuelve también los atributos JSON y la lista de categorías de cada
// producto, útil para el panel admin.
async function listar(req, res) {
  const { categoria } = req.query;

  let sql = `
    SELECT
      p.id,
      p.nombre,
      p.descripcion,
      p.imagen_url,
      p.atributos,
      GROUP_CONCAT(DISTINCT c.id) AS categorias_ids,
      GROUP_CONCAT(DISTINCT c.nombre SEPARATOR '||') AS categorias_nombres
    FROM productos p
    LEFT JOIN producto_categoria pc ON pc.producto_id = p.id
    LEFT JOIN categorias c ON c.id = pc.categoria_id
  `;
  const params = [];

  if (categoria) {
    const [descendientes] = await pool.query(
      `WITH RECURSIVE arbol AS (
         SELECT id FROM categorias WHERE id = ?
         UNION ALL
         SELECT c.id FROM categorias c
         JOIN arbol a ON c.padre_id = a.id
       )
       SELECT id FROM arbol`,
      [categoria]
    );
    const ids = descendientes.map((c) => c.id);
    if (ids.length === 0) return res.json([]);

    sql += ` WHERE pc.categoria_id IN (${ids.map(() => "?").join(",")})`;
    params.push(...ids);
  }

  sql += " GROUP BY p.id, p.nombre, p.descripcion, p.imagen_url, p.atributos ORDER BY p.nombre";

  const [rows] = await pool.query(sql, params);

  const productos = rows.map((r) => {
    const ids = r.categorias_ids ? r.categorias_ids.split(",") : [];
    const nombres = r.categorias_nombres ? r.categorias_nombres.split("||") : [];

    return {
      id: r.id,
      nombre: r.nombre,
      descripcion: r.descripcion,
      imagen_url: r.imagen_url,
      // mysql2 devuelve el JSON ya parseado como objeto; si por alguna razón
      // llegara como string, lo parseamos. Si es null, queda null.
      atributos: parsearAtributos(r.atributos),
      categorias: ids.map((id, i) => ({
        id: parseInt(id, 10),
        nombre: nombres[i] || "",
      })),
    };
  });

  res.json(productos);
}

// Helper: acepta tanto un objeto (ya parseado por mysql2) como un string JSON
// o null, y devuelve siempre un objeto o null.
function parsearAtributos(valor) {
  if (valor == null) return null;
  if (typeof valor === "object") return valor;
  try {
    return JSON.parse(valor);
  } catch {
    return null;
  }
}

// Administrador: crear producto (RF-14, CP-12). Sin campos de precio/stock por diseño.
async function crear(req, res) {
  const {
    nombre,
    descripcion = null,
    imagen_url = null,
    atributos = null,
    categorias = [],
  } = req.body;

  if (!nombre) {
    return res.status(400).json({ error: "El nombre del producto es obligatorio." });
  }

  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();

    const [result] = await conn.query(
      "INSERT INTO productos (nombre, descripcion, imagen_url, atributos, creado_por) VALUES (?, ?, ?, ?, ?)",
      [
        nombre,
        descripcion,
        imagen_url,
        atributos ? JSON.stringify(atributos) : null,
        req.admin.id,
      ]
    );
    const productoId = result.insertId;

    for (const categoriaId of categorias) {
      await conn.query(
        "INSERT INTO producto_categoria (producto_id, categoria_id) VALUES (?, ?)",
        [productoId, categoriaId]
      );
    }

    await conn.commit();
    res.status(201).json({ id: productoId, nombre, descripcion, imagen_url, atributos });
  } catch (err) {
    await conn.rollback();
    throw err;
  } finally {
    conn.release();
  }
}

// Administrador: editar producto existente (RF-14, CP-13).
async function actualizar(req, res) {
  const { id } = req.params;
  const { nombre, descripcion, imagen_url, atributos, categorias } = req.body;

  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();

    // Actualizar datos del producto. Si `atributos` llega undefined, se
    // conserva el valor actual; si llega null, se limpia.
    if (atributos !== undefined) {
      await conn.query(
        "UPDATE productos SET nombre = ?, descripcion = ?, imagen_url = ?, atributos = ? WHERE id = ?",
        [
          nombre,
          descripcion,
          imagen_url,
          atributos ? JSON.stringify(atributos) : null,
          id,
        ]
      );
    } else {
      await conn.query(
        "UPDATE productos SET nombre = ?, descripcion = ?, imagen_url = ? WHERE id = ?",
        [nombre, descripcion, imagen_url, id]
      );
    }

    if (Array.isArray(categorias)) {
      await conn.query("DELETE FROM producto_categoria WHERE producto_id = ?", [id]);
      for (const categoriaId of categorias) {
        await conn.query(
          "INSERT INTO producto_categoria (producto_id, categoria_id) VALUES (?, ?)",
          [id, categoriaId]
        );
      }
    }

    await conn.commit();
    res.json({ ok: true });
  } catch (err) {
    await conn.rollback();
    throw err;
  } finally {
    conn.release();
  }
}

// Administrador: eliminar producto. producto_categoria se limpia en cascada (CP-14).
async function eliminar(req, res) {
  const { id } = req.params;
  await pool.query("DELETE FROM productos WHERE id = ?", [id]);
  res.json({ ok: true });
}

module.exports = { listar, crear, actualizar, eliminar };