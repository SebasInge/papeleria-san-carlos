const express = require("express");
const cors = require("cors");
const path = require("node:path");

const authRoutes = require("./routes/auth.routes");
const productosRoutes = require("./routes/productos.routes");
const categoriasRoutes = require("./routes/categorias.routes");
const bannersRoutes = require("./routes/banners.routes");

const app = express();

const uploadRoutes = require("./routes/upload.routes");

app.use("/api/upload", uploadRoutes);

app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname, "../frontend")));

app.get("/api/health", (req, res) => res.json({ ok: true }));

app.get('/admin', (req, res) => {
  res.sendFile(path.join(__dirname, '../frontend/admin.html'));
});

app.use("/api/auth", authRoutes);
app.use("/api/productos", productosRoutes);
app.use("/api/categorias", categoriasRoutes);
app.use("/api/banners", bannersRoutes);

// Manejador de errores centralizado: evita que un error de la base de
// datos u otra excepción tumbe el proceso o filtre detalles internos.
app.use((err, req, res, next) => {
  console.error(err);
  res.status(500).json({ error: "Error interno del servidor." });
});

module.exports = app;
