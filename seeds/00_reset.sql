-- =====================================================================
-- RESET DE BASE DE DATOS — SOLO PARA DESARROLLO
-- =====================================================================
-- ⚠️  ADVERTENCIA: este script BORRA todas las tablas del proyecto.
--     NUNCA lo ejecutes en producción. NUNCA lo ejecutes si tienes datos
--     que no puedas perder.
--
-- Uso:
--     mysql -u root -p < seeds/00_reset.sql
-- =====================================================================

-- Desactiva checks de FK para poder borrar en cualquier orden
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS producto_categoria;
DROP TABLE IF EXISTS banners;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS categorias;
DROP TABLE IF EXISTS administradores;

SET FOREIGN_KEY_CHECKS = 1;

-- La base de datos se mantiene; schema.sql la recrea si no existe
-- y crea las tablas de nuevo.