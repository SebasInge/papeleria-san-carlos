const express = require("express");
const router = express.Router();
const { asyncHandler } = require("../middleware/asyncHandler");
const { login } = require("../controllers/auth.controller");

// POST /api/auth/login  (RF-02, CP-01, CP-02)
router.post("/login", asyncHandler(login));

module.exports = router;
