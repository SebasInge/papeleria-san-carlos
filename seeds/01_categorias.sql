-- =====================================================================
-- Categorías — Papelería San Carlos
-- Árbol jerárquico de N niveles
--
-- Idempotente: puede re-ejecutarse sin duplicar filas.
-- Se inserta de arriba hacia abajo, para que cada hijo encuentre
-- siempre a su padre ya creado.
-- =====================================================================

USE papeleria_san_carlos;

-- ---------------------------------------------------------------------
-- NIVEL 1 — Raíces
-- ---------------------------------------------------------------------
INSERT INTO categorias (nombre, tipo, icono, activa, padre_id, orden)
SELECT datos.nombre, datos.tipo, datos.icono, datos.activa, NULL, datos.orden
FROM (
  SELECT 'Papelería' AS nombre, 'normal'    AS tipo, 'papel'    AS icono, TRUE  AS activa, 1 AS orden
  UNION ALL SELECT 'Halloween', 'temporada', 'fantasma', FALSE, 2
  UNION ALL SELECT 'Navidad',   'temporada', 'estrella', FALSE, 3
) AS datos
LEFT JOIN categorias existente
  ON existente.nombre = datos.nombre AND existente.padre_id IS NULL
WHERE existente.id IS NULL;

-- ---------------------------------------------------------------------
-- NIVEL 2 — Bajo Papelería
-- ---------------------------------------------------------------------
INSERT INTO categorias (nombre, tipo, icono, activa, padre_id, orden)
SELECT datos.nombre, 'normal', NULL, TRUE, padre.id, datos.orden
FROM (
  SELECT 'Escolar' AS nombre, 1 AS orden
  UNION ALL SELECT 'Archivo y organización', 2
  UNION ALL SELECT 'Escritorio', 3
) AS datos
JOIN categorias padre
  ON padre.nombre = 'Papelería' AND padre.padre_id IS NULL
LEFT JOIN categorias existente
  ON existente.nombre = datos.nombre AND existente.padre_id = padre.id
WHERE existente.id IS NULL;

-- ---------------------------------------------------------------------
-- NIVEL 3 — Bajo Escolar
-- ---------------------------------------------------------------------
INSERT INTO categorias (nombre, tipo, icono, activa, padre_id, orden)
SELECT datos.nombre, 'normal', NULL, TRUE, padre.id, datos.orden
FROM (
  SELECT 'Escritura' AS nombre, 1 AS orden
  UNION ALL SELECT 'Corrección y afilado', 2
  UNION ALL SELECT 'Marcación', 3
  UNION ALL SELECT 'Cuadernos y libretas', 4
  UNION ALL SELECT 'Libros y lectura', 5
  UNION ALL SELECT 'Geometría', 6
  UNION ALL SELECT 'Colores y crayones', 7
  UNION ALL SELECT 'Plumones jumbo', 8
  UNION ALL SELECT 'Pegantes y cintas', 9
  UNION ALL SELECT 'Papeles y cartones', 10
  UNION ALL SELECT 'Didácticos', 11
  UNION ALL SELECT 'Arte', 12
) AS datos
JOIN categorias padre
  ON padre.nombre = 'Escolar'
LEFT JOIN categorias existente
  ON existente.nombre = datos.nombre AND existente.padre_id = padre.id
WHERE existente.id IS NULL;

-- ---------------------------------------------------------------------
-- NIVEL 3 — Bajo Archivo y organización
-- ---------------------------------------------------------------------
INSERT INTO categorias (nombre, tipo, icono, activa, padre_id, orden)
SELECT datos.nombre, 'normal', NULL, TRUE, padre.id, datos.orden
FROM (
  SELECT 'Archivadores' AS nombre, 1 AS orden
  UNION ALL SELECT 'Folders', 2
  UNION ALL SELECT 'Carpetas', 3
  UNION ALL SELECT 'Sobres', 4
  UNION ALL SELECT 'Tablas y tableros', 5
) AS datos
JOIN categorias padre
  ON padre.nombre = 'Archivo y organización'
LEFT JOIN categorias existente
  ON existente.nombre = datos.nombre AND existente.padre_id = padre.id
WHERE existente.id IS NULL;

-- ---------------------------------------------------------------------
-- NIVEL 3 — Bajo Escritorios
-- ---------------------------------------------------------------------
INSERT INTO categorias (nombre, tipo, icono, activa, padre_id, orden)
SELECT datos.nombre, 'normal', NULL, TRUE, padre.id, datos.orden
FROM (
  SELECT 'Grapadoras' AS nombre, 1 AS orden
  UNION ALL SELECT 'Perforadoras', 2
  UNION ALL SELECT 'Tijeras y bisturíes', 3
  UNION ALL SELECT 'Lupas y punzones', 4
  UNION ALL SELECT 'Otros', 5
) AS datos
JOIN categorias padre
  ON padre.nombre = 'Escritorios'
LEFT JOIN categorias existente
  ON existente.nombre = datos.nombre AND existente.padre_id = padre.id
WHERE existente.id IS NULL;

-- ---------------------------------------------------------------------
-- NIVEL 4 — Bajo Escritura
-- ---------------------------------------------------------------------
INSERT INTO categorias (nombre, tipo, icono, activa, padre_id, orden)
SELECT datos.nombre, 'normal', NULL, TRUE, padre.id, datos.orden
FROM (
  SELECT 'Lápices' AS nombre, 1 AS orden
  UNION ALL SELECT 'Lapiceros', 2
  UNION ALL SELECT 'Portaminas', 3
  UNION ALL SELECT 'Plumas', 4
  UNION ALL SELECT 'Micropuntas', 5
  UNION ALL SELECT 'Rapidógrafos', 6
) AS datos
JOIN categorias padre ON padre.nombre = 'Escritura'
LEFT JOIN categorias existente
  ON existente.nombre = datos.nombre AND existente.padre_id = padre.id
WHERE existente.id IS NULL;

-- ---------------------------------------------------------------------
-- NIVEL 4 — Bajo Corrección y afilado
-- ---------------------------------------------------------------------
INSERT INTO categorias (nombre, tipo, icono, activa, padre_id, orden)
SELECT datos.nombre, 'normal', NULL, TRUE, padre.id, datos.orden
FROM (
  SELECT 'Borradores' AS nombre, 1 AS orden
  UNION ALL SELECT 'Sacapuntas', 2
  UNION ALL SELECT 'Correctores', 3
) AS datos
JOIN categorias padre ON padre.nombre = 'Corrección y afilado'
LEFT JOIN categorias existente
  ON existente.nombre = datos.nombre AND existente.padre_id = padre.id
WHERE existente.id IS NULL;

-- ---------------------------------------------------------------------
-- NIVEL 4 — Bajo Marcación
-- ---------------------------------------------------------------------
INSERT INTO categorias (nombre, tipo, icono, activa, padre_id, orden)
SELECT datos.nombre, 'normal', NULL, TRUE, padre.id, datos.orden
FROM (
  SELECT 'Marcadores' AS nombre, 1 AS orden
  UNION ALL SELECT 'Resaltadores', 2
) AS datos
JOIN categorias padre ON padre.nombre = 'Marcación'
LEFT JOIN categorias existente
  ON existente.nombre = datos.nombre AND existente.padre_id = padre.id
WHERE existente.id IS NULL;

-- ---------------------------------------------------------------------
-- NIVEL 4 — Bajo Cuadernos y libretas
-- ---------------------------------------------------------------------
INSERT INTO categorias (nombre, tipo, icono, activa, padre_id, orden)
SELECT datos.nombre, 'normal', NULL, TRUE, padre.id, datos.orden
FROM (
  SELECT 'Cosidos' AS nombre, 1 AS orden
  UNION ALL SELECT 'Anillados', 2
  UNION ALL SELECT 'Agendas', 3
  UNION ALL SELECT 'Mininotas', 4
  UNION ALL SELECT 'Música', 5
) AS datos
JOIN categorias padre ON padre.nombre = 'Cuadernos y libretas'
LEFT JOIN categorias existente
  ON existente.nombre = datos.nombre AND existente.padre_id = padre.id
WHERE existente.id IS NULL;

-- ---------------------------------------------------------------------
-- NIVEL 4 — Bajo Libros y lectura
-- ---------------------------------------------------------------------
INSERT INTO categorias (nombre, tipo, icono, activa, padre_id, orden)
SELECT datos.nombre, 'normal', NULL, TRUE, padre.id, datos.orden
FROM (
  SELECT 'Obras literarias' AS nombre, 1 AS orden
  UNION ALL SELECT 'Diccionarios', 2
  UNION ALL SELECT 'Cartilla Nacho', 3
  UNION ALL SELECT 'Pasatiempos', 4
  UNION ALL SELECT 'Atlas', 5
) AS datos
JOIN categorias padre ON padre.nombre = 'Libros y lectura'
LEFT JOIN categorias existente
  ON existente.nombre = datos.nombre AND existente.padre_id = padre.id
WHERE existente.id IS NULL;

-- ---------------------------------------------------------------------
-- NIVEL 4 — Bajo Pegantes y cintas
-- ---------------------------------------------------------------------
INSERT INTO categorias (nombre, tipo, icono, activa, padre_id, orden)
SELECT datos.nombre, 'normal', NULL, TRUE, padre.id, datos.orden
FROM (
  SELECT 'Pegantes' AS nombre, 1 AS orden
  UNION ALL SELECT 'Cintas', 2
) AS datos
JOIN categorias padre ON padre.nombre = 'Pegantes y cintas'
LEFT JOIN categorias existente
  ON existente.nombre = datos.nombre AND existente.padre_id = padre.id
WHERE existente.id IS NULL;

-- ---------------------------------------------------------------------
-- NIVEL 4 — Bajo Papeles y cartones
-- ---------------------------------------------------------------------
INSERT INTO categorias (nombre, tipo, icono, activa, padre_id, orden)
SELECT datos.nombre, 'normal', NULL, TRUE, padre.id, datos.orden
FROM (
  SELECT 'Papel' AS nombre, 1 AS orden
  UNION ALL SELECT 'Cartulinas', 2
  UNION ALL SELECT 'Cartones', 3
  UNION ALL SELECT 'Blocs', 4
  UNION ALL SELECT 'Hojas', 5
  UNION ALL SELECT 'Icopor', 6
) AS datos
JOIN categorias padre ON padre.nombre = 'Papeles y cartones'
LEFT JOIN categorias existente
  ON existente.nombre = datos.nombre AND existente.padre_id = padre.id
WHERE existente.id IS NULL;

-- ---------------------------------------------------------------------
-- NIVEL 4 — Bajo Didácticos
-- ---------------------------------------------------------------------
INSERT INTO categorias (nombre, tipo, icono, activa, padre_id, orden)
SELECT datos.nombre, 'normal', NULL, TRUE, padre.id, datos.orden
FROM (
  SELECT 'Tablas de punzado' AS nombre, 1 AS orden
  UNION ALL SELECT 'Foamy y escarchas', 2
  UNION ALL SELECT 'Palos y bajalenguas', 3
) AS datos
JOIN categorias padre ON padre.nombre = 'Didácticos'
LEFT JOIN categorias existente
  ON existente.nombre = datos.nombre AND existente.padre_id = padre.id
WHERE existente.id IS NULL;

-- ---------------------------------------------------------------------
-- NIVEL 4 — Bajo Arte
-- ---------------------------------------------------------------------
INSERT INTO categorias (nombre, tipo, icono, activa, padre_id, orden)
SELECT datos.nombre, 'normal', NULL, TRUE, padre.id, datos.orden
FROM (
  SELECT 'Pinturas' AS nombre, 1 AS orden
  UNION ALL SELECT 'Pinceles y mezcladores', 2
  UNION ALL SELECT 'Lienzos y libros de dibujo', 3
  UNION ALL SELECT 'Colores y plumones', 4
  UNION ALL SELECT 'Manualidades', 5
  UNION ALL SELECT 'Didácticos arte', 6
) AS datos
JOIN categorias padre ON padre.nombre = 'Arte'
LEFT JOIN categorias existente
  ON existente.nombre = datos.nombre AND existente.padre_id = padre.id
WHERE existente.id IS NULL;