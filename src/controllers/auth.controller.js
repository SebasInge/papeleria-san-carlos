// Autenticación de administradores (RF-02).
// No existe registro de "clientes": el catálogo es público, solo el
// administrador necesita cuenta (ver CP-01, CP-02, CP-03).
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const pool = require("../config/db");

async function login(req, res) {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ error: "Email y contraseña son obligatorios." });
  }

  const [rows] = await pool.query(
    "SELECT id, nombre, email, password_hash FROM administradores WHERE email = ?",
    [email]
  );

  const admin = rows[0];
  // Mensaje genérico en ambos casos de fallo, para no revelar cuál campo fue incorrecto (CP-02).
  if (!admin) {
    return res.status(401).json({ error: "Credenciales inválidas." });
  }

  const valido = await bcrypt.compare(password, admin.password_hash);
  if (!valido) {
    return res.status(401).json({ error: "Credenciales inválidas." });
  }

  const token = jwt.sign(
    { id: admin.id, email: admin.email },
    process.env.JWT_SECRET,
    { expiresIn: process.env.JWT_EXPIRES_IN || "8h" }
  );

  res.json({
    token,
    admin: { id: admin.id, nombre: admin.nombre, email: admin.email },
  });
}

module.exports = { login };
