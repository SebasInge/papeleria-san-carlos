const express = require("express");
const router = express.Router();
const { requireAuth } = require("../middleware/auth.middleware");
const { asyncHandler } = require("../middleware/asyncHandler");
const productos = require("../controllers/productos.controller");

// --- Ruta pública (RF-01, RF-07) ---
router.get("/", asyncHandler(productos.listar));          // GET /api/productos?categoria=ID

// --- Rutas de administración (RF-14, protegidas) ---
router.post("/", requireAuth, asyncHandler(productos.crear));
router.put("/:id", requireAuth, asyncHandler(productos.actualizar));
router.delete("/:id", requireAuth, asyncHandler(productos.eliminar));

module.exports = router;
