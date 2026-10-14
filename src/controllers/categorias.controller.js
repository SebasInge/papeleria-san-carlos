// Categorías: árbol de hasta 3 niveles, normales y de temporada (RF-07, RF-08, RF-11, RF-13).
const pool = require("../config/db");

// Público: árbol de categorías visibles (barra lateral con acordeón, RF-11/RF-13).
// tipo/activa solo gatean la visibilidad de temporada; se aplica igual en
// cualquier nivel, pero en la práctica solo la raíz suele usar 'temporada'.
async function listarPublicas(req, res) {
  const [rows] = await pool.query(
    `SELECT id, nombre, padre_id, tipo, icono
     FROM categorias
     WHERE tipo = 'normal' OR (tipo = 'temporada' AND activa = TRUE)
     ORDER BY orden, nombre`
  );

  const porId = new Map(rows.map((r) => [r.id, { ...r, hijos: [] }]));
  const raices = [];
  for (const cat of porId.values()) {
    if (cat.padre_id === null) {
      raices.push(cat);
    } else {
      const padre = porId.get(cat.padre_id);
      // Si el padre no pasó el filtro de visibilidad (p. ej. temporada
      // inactiva), sus hijos tampoco se muestran.
      if (padre) padre.hijos.push(cat);
    }
  }
  res.json(raices);
}

// Administrador: lista plana de todas las categorías (incluye inactivas e
// hijos), con su padre_id, para gestión en el panel/Postman.
async function listarTodas(req, res) {
  const [rows] = await pool.query(
    "SELECT * FROM categorias ORDER BY padre_id IS NULL DESC, orden, nombre"
  );
  res.json(rows);
}

async function crear(req, res) {
  const { nombre, tipo = "normal", icono = null, padre_id = null, orden = 0 } = req.body;
  if (!nombre) return res.status(400).json({ error: "El nombre de la categoría es obligatorio." });

  // La restricción UNIQUE (padre_id, nombre) de la base de datos no aplica
  // entre categorías raíz (padre_id NULL nunca es "igual" a sí mismo en
  // InnoDB), así que la unicidad de nombre entre raíces se valida aquí.
  if (!padre_id) {
    const [[existente]] = await pool.query(
      "SELECT id FROM categorias WHERE padre_id IS NULL AND nombre = ?",
      [nombre]
    );
    if (existente) {
      return res.status(400).json({ error: "Ya existe una categoría raíz con ese nombre." });
    }
  }

  const [result] = await pool.query(
    "INSERT INTO categorias (nombre, tipo, icono, padre_id, orden) VALUES (?, ?, ?, ?, ?)",
    [nombre, tipo, icono, padre_id, orden]
  );
  res.status(201).json({ id: result.insertId, nombre, tipo, icono, padre_id, orden, activa: true });
}

// Solo actualiza los campos enviados (COALESCE conserva el resto), mismo
// criterio que se aplicó en banners.controller.js para evitar sobrescribir
// con NULL campos que el administrador no envió.
async function actualizar(req, res) {
  const { id } = req.params;
  const { nombre, tipo, icono, padre_id, orden } = req.body;

  await pool.query(
    `UPDATE categorias
     SET nombre   = COALESCE(?, nombre),
         tipo     = COALESCE(?, tipo),
         icono    = COALESCE(?, icono),
         padre_id = COALESCE(?, padre_id),
         orden    = COALESCE(?, orden)
     WHERE id = ?`,
    [nombre ?? null, tipo ?? null, icono ?? null, padre_id ?? null, orden ?? null, id]
  );
  res.json({ ok: true });
}

// Activar/desactivar manualmente una categoría de temporada (RF-08, CP-05/CP-06).
async function cambiarEstado(req, res) {
  const { id } = req.params;
  const { activa } = req.body;

  await pool.query("UPDATE categorias SET activa = ? WHERE id = ?", [!!activa, id]);
  res.json({ ok: true, activa: !!activa });
}

// Si la categoría tiene subcategorías o productos asociados, la base de
// datos rechaza el borrado (ON DELETE RESTRICT). Se traduce ese error a
// un 409 con mensaje claro en vez de dejarlo caer como 500 genérico.
async function eliminar(req, res) {
  const { id } = req.params;
  try {
    await pool.query("DELETE FROM categorias WHERE id = ?", [id]);
    res.json({ ok: true });
  } catch (err) {
    if (err.code === "ER_ROW_IS_REFERENCED_2" || err.code === "ER_ROW_IS_REFERENCED") {
      return res.status(409).json({
        error: "No se puede eliminar: la categoría tiene subcategorías o productos asociados.",
      });
    }
    throw err;
  }
}

module.exports = { listarPublicas, listarTodas, crear, actualizar, cambiarEstado, eliminar };
