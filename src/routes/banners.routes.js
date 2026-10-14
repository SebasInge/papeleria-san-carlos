const express = require("express");
const router = express.Router();
const { requireAuth } = require("../middleware/auth.middleware");
const { asyncHandler } = require("../middleware/asyncHandler");
const banners = require("../controllers/banners.controller");

// --- Ruta pública (RF-05) ---
router.get("/", asyncHandler(banners.listarActivos));

// --- Rutas de administración (RF-06, protegidas) ---
router.post("/", requireAuth, asyncHandler(banners.crear));
router.put("/:id", requireAuth, asyncHandler(banners.actualizar));
router.delete("/:id", requireAuth, asyncHandler(banners.eliminar));

module.exports = router;
