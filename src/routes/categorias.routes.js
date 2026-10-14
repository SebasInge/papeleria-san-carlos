const express = require("express");
const router = express.Router();
const { requireAuth } = require("../middleware/auth.middleware");
const { asyncHandler } = require("../middleware/asyncHandler");
const categorias = require("../controllers/categorias.controller");

// --- Rutas públicas (RF-07, RF-08, RF-13) ---
router.get("/", asyncHandler(categorias.listarPublicas));

// --- Rutas de administración (RF-14, protegidas) ---
router.get("/todas", requireAuth, asyncHandler(categorias.listarTodas));
router.post("/", requireAuth, asyncHandler(categorias.crear));
router.put("/:id", requireAuth, asyncHandler(categorias.actualizar));
router.patch("/:id/estado", requireAuth, asyncHandler(categorias.cambiarEstado)); // activar/desactivar temporada
router.delete("/:id", requireAuth, asyncHandler(categorias.eliminar));

module.exports = router;
