-- =====================================================================
-- Datos de prueba para demo — Papelería San Carlos
-- Ejecutar DESPUÉS de schema.sql y de crear el primer administrador
-- con scripts/seedAdmin.js.
-- =====================================================================

USE papeleria_san_carlos;

-- ---------------------------------------------------------------------
-- Categorías (normales + de temporada)
-- ---------------------------------------------------------------------
-- ---------------------------------------------------------------------
-- Categorías raíz (nivel 1: normales + de temporada)
-- ---------------------------------------------------------------------
INSERT INTO categorias (nombre, tipo, icono, activa, padre_id)
SELECT datos.nombre, datos.tipo, datos.icono, datos.activa, NULL
FROM (
  SELECT 'Escolar' AS nombre, 'normal' AS tipo, 'cuaderno' AS icono, TRUE AS activa
  UNION ALL SELECT 'Oficina', 'normal', 'carpeta', TRUE
  UNION ALL SELECT 'Arte y pintura', 'normal', 'paleta', TRUE
  UNION ALL SELECT 'Halloween', 'temporada', 'fantasma', FALSE
  UNION ALL SELECT 'Navidad', 'temporada', 'estrella', FALSE
) AS datos
LEFT JOIN categorias existente
  ON existente.nombre = datos.nombre AND existente.padre_id IS NULL
WHERE existente.id IS NULL;

-- ---------------------------------------------------------------------
-- Subcategorías (nivel 2) de ejemplo, para poder probar el acordeón y la
-- herencia de productos (un producto en "Cuadernos" también debe verse
-- al navegar la raíz "Escolar").
-- ---------------------------------------------------------------------
INSERT INTO categorias (nombre, tipo, icono, activa, padre_id)
SELECT datos.nombre, 'normal', NULL, TRUE, padre.id
FROM (
  SELECT 'Cuadernos' AS nombre, 'Escolar' AS padre_nombre
  UNION ALL SELECT 'Mochilas y estuches', 'Escolar'
  UNION ALL SELECT 'Papel', 'Oficina'
  UNION ALL SELECT 'Organización', 'Oficina'
) AS datos
JOIN categorias padre
  ON padre.nombre = datos.padre_nombre AND padre.padre_id IS NULL
LEFT JOIN categorias existente
  ON existente.nombre = datos.nombre AND existente.padre_id = padre.id
WHERE existente.id IS NULL;

-- ---------------------------------------------------------------------
-- Productos
-- ---------------------------------------------------------------------
INSERT INTO productos (nombre, descripcion, imagen_url) VALUES
  ('Cuaderno cuadriculado 100 hojas', 'Cuaderno tamaño carta, pasta dura, cuadriculado grande.', NULL),
  ('Set de colores x24',              'Colores de madera, caja metálica, larga duración.', NULL),
  ('Mochila escolar',                 'Mochila resistente con compartimento para portátil.', NULL),
  ('Estuche triple',                  'Estuche con tres compartimentos y cierre reforzado.', NULL),
  ('Resma de papel carta',            'Papel bond blanco, 500 hojas, 75 g.', NULL),
  ('Carpeta AZ oficio',               'Carpeta de palanca tamaño oficio, varios colores.', NULL),
  ('Grapadora estándar',              'Grapadora de escritorio, capacidad 20 hojas.', NULL),
  ('Kit de pinceles x12',             'Set de pinceles de distintos grosores para acrílico y acuarela.', NULL),
  ('Lienzo 30x40 cm',                 'Lienzo de algodón preparado, listo para pintar.', NULL),
  ('Disfraz de bruja infantil',       'Disfraz completo talla única infantil.', NULL),
  ('Calabaza decorativa',             'Calabaza de plástico decorativa para vitrina o mesa.', NULL),
  ('Set de esferas navideñas',        'Caja de 12 esferas decorativas para árbol de navidad.', NULL);

-- ---------------------------------------------------------------------
-- Relación producto-categoría
-- ---------------------------------------------------------------------
-- Se buscan los IDs por nombre porque AUTO_INCREMENT no garantiza que
-- estos productos sean los registros 1..12 si la base ya tenía datos.
INSERT INTO producto_categoria (producto_id, categoria_id)
SELECT p.id, c.id
FROM (
  -- Etiquetados directo a una subcategoría (nivel 2): deben verse tanto al
  -- navegar la subcategoría como su raíz, por herencia.
  SELECT 'Cuaderno cuadriculado 100 hojas' AS producto, 'Cuadernos' AS categoria
  UNION ALL SELECT 'Mochila escolar', 'Mochilas y estuches'
  UNION ALL SELECT 'Estuche triple', 'Mochilas y estuches'
  UNION ALL SELECT 'Resma de papel carta', 'Papel'
  UNION ALL SELECT 'Carpeta AZ oficio', 'Organización'
  -- Etiquetados directo a la raíz (sin subcategoría), para probar que ambos casos conviven.
  UNION ALL SELECT 'Set de colores x24', 'Escolar'
  UNION ALL SELECT 'Set de colores x24', 'Arte y pintura'
  UNION ALL SELECT 'Grapadora estándar', 'Oficina'
  UNION ALL SELECT 'Kit de pinceles x12', 'Arte y pintura'
  UNION ALL SELECT 'Lienzo 30x40 cm', 'Arte y pintura'
  UNION ALL SELECT 'Disfraz de bruja infantil', 'Halloween'
  UNION ALL SELECT 'Calabaza decorativa', 'Halloween'
  UNION ALL SELECT 'Set de esferas navideñas', 'Navidad'
) AS relaciones
JOIN productos p ON p.nombre = relaciones.producto
JOIN categorias c ON c.nombre = relaciones.categoria;

-- ---------------------------------------------------------------------
-- Banners (RF-05) — imágenes públicas temporales para la demo.
-- Reemplaza estas URLs por fotos reales del negocio antes de producción.
-- ---------------------------------------------------------------------
INSERT INTO banners (imagen_url, orden, activo) VALUES
  ('https://placehold.co/1600x600/ffd400/000000?text=Utiles+escolares', 1, TRUE),
  ('https://placehold.co/1600x600/ee4c8d/ffffff?text=Papeleria+San+Carlos', 2, TRUE),
  ('images/amoryamistad.png', 3, TRUE);
