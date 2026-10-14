// Script de un solo uso para crear el primer administrador.
// Uso:  node scripts/seedAdmin.js "Nombre Apellido" correo@ejemplo.com "unaContraseñaSegura"
require("dotenv").config();
const bcrypt = require("bcryptjs");
const pool = require("../src/config/db");

async function main() {
  const [nombre, email, password] = process.argv.slice(2);

  if (!nombre || !email || !password) {
    console.error(
      'Uso: node scripts/seedAdmin.js "Nombre Apellido" correo@ejemplo.com "contraseña"'
    );
    process.exit(1);
  }

  const [existentes] = await pool.query(
    "SELECT id FROM administradores WHERE email = ?",
    [email]
  );
  if (existentes.length > 0) {
    console.error(`Ya existe un administrador con el email ${email}.`);
    process.exit(1);
  }

  const hash = await bcrypt.hash(password, 10);
  const [result] = await pool.query(
    "INSERT INTO administradores (nombre, email, password_hash) VALUES (?, ?, ?)",
    [nombre, email, hash]
  );

  console.log(`Administrador creado con id ${result.insertId} (${email}).`);
  process.exit(0);
}

main().catch((err) => {
  console.error("Error creando el administrador:", err.message);
  process.exit(1);
});
