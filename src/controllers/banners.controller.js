// Banner de anuncios destacados del menú principal (RF-05, RF-06).
const pool = require("../config/db");

// Público: banners activos, en el orden configurado por el administrador.
async function listarActivos(req, res) {
  const [rows] = await pool.query(
    "SELECT id, imagen_url, orden FROM banners WHERE activo = TRUE ORDER BY orden"
  );
  res.json(rows);
}

// Administrador: agregar una imagen al banner.
async function crear(req, res) {
  const { imagen_url, orden = 0 } = req.body;
  if (!imagen_url) return res.status(400).json({ error: "La imagen del banner es obligatoria." });

  const [result] = await pool.query(
    "INSERT INTO banners (imagen_url, orden, creado_por) VALUES (?, ?, ?)",
    [imagen_url, orden, req.admin.id]
  );
  res.status(201).json({ id: result.insertId, imagen_url, orden });
}

// Administrador: reordenar o desactivar una imagen del banner.
// Solo actualiza los campos que el admin realmente envía (COALESCE conserva
// el valor actual en los demás), para que "desactivar" no exija reenviar
// imagen_url y orden.
async function actualizar(req, res) {
  const { id } = req.params;
  const { imagen_url, orden, activo } = req.body;

  await pool.query(
    `UPDATE banners
     SET imagen_url = COALESCE(?, imagen_url),
         orden      = COALESCE(?, orden),
         activo     = COALESCE(?, activo)
     WHERE id = ?`,
    [imagen_url ?? null, orden ?? null, activo ?? null, id]
  );
  res.json({ ok: true });
}

async function eliminar(req, res) {
  const { id } = req.params;
  await pool.query("DELETE FROM banners WHERE id = ?", [id]);
  res.json({ ok: true });
}

module.exports = { listarActivos, crear, actualizar, eliminar };
