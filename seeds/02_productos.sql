-- =====================================================================
-- Productos — Papelería San Carlos
-- =====================================================================
-- Idempotente:
--   - Cada producto se identifica por `nombre`. Se inserta solo si no existe.
--   - Las relaciones producto-categoría usan INSERT IGNORE + PK compuesta.
--
-- Convención de atributos JSON:
--   - Claves en minúscula, sin tildes.
--   - Valores en snake_case cuando aplique.
--   - Unidades incluidas en el valor ("0.7mm", "pliego", no en la clave).
-- =====================================================================

USE papeleria_san_carlos;

-- ---------------------------------------------------------------------
-- Escolar > Escritura > Lápices
-- ---------------------------------------------------------------------
INSERT INTO productos (nombre, descripcion, atributos)
SELECT d.nombre, d.descripcion, d.atributos
FROM (
  SELECT 'Lápiz carboncillo' AS nombre,
         'Lápiz de carboncillo para dibujo artístico.' AS descripcion,
         '{"tipo":"carboncillo"}' AS atributos
  UNION ALL SELECT 'Lápiz graduado',
                    'Lápiz de grafito con mina graduada (2H a 6B).',
                    '{"tipo":"graduado"}'
  UNION ALL SELECT 'Lápiz de escritura',
                    'Lápiz de grafito estándar para escritura.',
                    '{"tipo":"escritura"}'
  UNION ALL SELECT 'Lápiz jumbo',
                    'Lápiz de grosor jumbo, ideal para niños.',
                    '{"tipo":"jumbo"}'
) AS d
LEFT JOIN productos p ON p.nombre = d.nombre
WHERE p.id IS NULL;

INSERT IGNORE INTO producto_categoria (producto_id, categoria_id)
SELECT p.id, c.id
FROM (
  SELECT 'Lápiz carboncillo' AS producto, 'Lápices' AS categoria
  UNION ALL SELECT 'Lápiz graduado',     'Lápices'
  UNION ALL SELECT 'Lápiz de escritura', 'Lápices'
  UNION ALL SELECT 'Lápiz jumbo',        'Lápices'
) AS r
JOIN productos p ON p.nombre = r.producto
JOIN categorias c ON c.nombre = r.categoria;

-- ---------------------------------------------------------------------
-- Escolar > Escritura > Lapiceros
-- ---------------------------------------------------------------------
INSERT INTO productos (nombre, descripcion, atributos)
SELECT d.nombre, d.descripcion, d.atributos
FROM (
  SELECT 'Lapicero tapa' AS nombre,
         'Lapicero con tapa, varios colores de tinta.' AS descripcion,
         '{"tipo":"tapa"}' AS atributos
  UNION ALL SELECT 'Lapicero retráctil',
                    'Lapicero con mecanismo retráctil.',
                    '{"tipo":"retractil"}'
  UNION ALL SELECT 'Lapicero gel',
                    'Lapicero de tinta en gel, escritura suave.',
                    '{"tipo_tinta":"gel"}'
  UNION ALL SELECT 'Lapicero semigel',
                    'Lapicero de tinta semigel, secado rápido.',
                    '{"tipo_tinta":"semigel"}'
  UNION ALL SELECT 'Lapicero alto rendimiento',
                    'Lapicero de larga duración, escritura continua.',
                    '{"tipo":"alto_rendimiento"}'
  UNION ALL SELECT 'Lapicero tinta en gel',
                    'Lapicero con recarga de tinta en gel.',
                    '{"tipo_tinta":"gel"}'
  UNION ALL SELECT 'Lapicero tinta en gel mina roller',
                    'Lapicero roller con tinta en gel.',
                    '{"tipo_tinta":"gel","tipo_punta":"roller"}'
  UNION ALL SELECT 'Lapicero borrable',
                    'Lapicero con tinta borrable.',
                    '{"borrable":true}'
) AS d
LEFT JOIN productos p ON p.nombre = d.nombre
WHERE p.id IS NULL;

INSERT IGNORE INTO producto_categoria (producto_id, categoria_id)
SELECT p.id, c.id
FROM (
  SELECT 'Lapicero tapa' AS producto,                  'Lapiceros' AS categoria
  UNION ALL SELECT 'Lapicero retráctil',               'Lapiceros'
  UNION ALL SELECT 'Lapicero gel',                     'Lapiceros'
  UNION ALL SELECT 'Lapicero semigel',                 'Lapiceros'
  UNION ALL SELECT 'Lapicero alto rendimiento',        'Lapiceros'
  UNION ALL SELECT 'Lapicero tinta en gel',            'Lapiceros'
  UNION ALL SELECT 'Lapicero tinta en gel mina roller','Lapiceros'
  UNION ALL SELECT 'Lapicero borrable',                'Lapiceros'
) AS r
JOIN productos p ON p.nombre = r.producto
JOIN categorias c ON c.nombre = r.categoria;

-- ---------------------------------------------------------------------
-- Escolar > Escritura > Portaminas
-- ---------------------------------------------------------------------
INSERT INTO productos (nombre, descripcion, atributos)
SELECT d.nombre, d.descripcion, d.atributos
FROM (
  SELECT 'Portaminas 0.7' AS nombre, 'Portaminas con mina de 0.7 mm.' AS descripcion,
         '{"grosor_mina":"0.7mm"}' AS atributos
  UNION ALL SELECT 'Portaminas 0.5',     'Portaminas con mina de 0.5 mm.',      '{"grosor_mina":"0.5mm"}'
  UNION ALL SELECT 'Portaminas 2.0',     'Portaminas con mina de 2.0 mm.',      '{"grosor_mina":"2.0mm"}'
  UNION ALL SELECT 'Portaminas 1.3',     'Portaminas con mina de 1.3 mm.',      '{"grosor_mina":"1.3mm"}'
  UNION ALL SELECT 'Minas decorativas x10',
                    'Tubo de 10 minas decorativas para portaminas.',
                    '{"cantidad":10,"tipo":"decorativas"}'
) AS d
LEFT JOIN productos p ON p.nombre = d.nombre
WHERE p.id IS NULL;

INSERT IGNORE INTO producto_categoria (producto_id, categoria_id)
SELECT p.id, c.id
FROM (
  SELECT 'Portaminas 0.7' AS producto,        'Portaminas' AS categoria
  UNION ALL SELECT 'Portaminas 0.5',          'Portaminas'
  UNION ALL SELECT 'Portaminas 2.0',          'Portaminas'
  UNION ALL SELECT 'Portaminas 1.3',          'Portaminas'
  UNION ALL SELECT 'Minas decorativas x10',   'Portaminas'
) AS r
JOIN productos p ON p.nombre = r.producto
JOIN categorias c ON c.nombre = r.categoria;

-- ---------------------------------------------------------------------
-- Escolar > Escritura > Micropuntas
-- ---------------------------------------------------------------------
INSERT INTO productos (nombre, descripcion, atributos)
SELECT d.nombre, d.descripcion, d.atributos
FROM (
  SELECT 'Micropunta Papermate' AS nombre, 'Micropunta marca Papermate.' AS descripcion,
         '{"marca":"Papermate"}' AS atributos
  UNION ALL SELECT 'Micropunta Sharpie', 'Micropunta marca Sharpie.', '{"marca":"Sharpie"}'
  UNION ALL SELECT 'Micropunta Pelikan', 'Micropunta marca Pelikan.', '{"marca":"Pelikan"}'
  UNION ALL SELECT 'Micropunta Offi Esco', 'Micropunta marca Offi Esco.', '{"marca":"Offi Esco"}'
  UNION ALL SELECT 'Micropunta Kores',   'Micropunta marca Kores.',   '{"marca":"Kores"}'
) AS d
LEFT JOIN productos p ON p.nombre = d.nombre
WHERE p.id IS NULL;

INSERT IGNORE INTO producto_categoria (producto_id, categoria_id)
SELECT p.id, c.id
FROM (
  SELECT 'Micropunta Papermate' AS producto, 'Micropuntas' AS categoria
  UNION ALL SELECT 'Micropunta Sharpie',      'Micropuntas'
  UNION ALL SELECT 'Micropunta Pelikan',      'Micropuntas'
  UNION ALL SELECT 'Micropunta Offi Esco',    'Micropuntas'
  UNION ALL SELECT 'Micropunta Kores',        'Micropuntas'
) AS r
JOIN productos p ON p.nombre = r.producto
JOIN categorias c ON c.nombre = r.categoria;

-- ---------------------------------------------------------------------
-- Escolar > Escritura > Rapidógrafos
-- ---------------------------------------------------------------------
INSERT INTO productos (nombre, descripcion, atributos)
SELECT 'Rapidógrafo Edding',
       'Rapidógrafo marca Edding, para trazado técnico.',
       '{"marca":"Edding"}'
WHERE NOT EXISTS (SELECT 1 FROM productos WHERE nombre = 'Rapidógrafo Edding');

INSERT IGNORE INTO producto_categoria (producto_id, categoria_id)
SELECT p.id, c.id
FROM productos p
JOIN categorias c ON c.nombre = 'Rapidógrafos'
WHERE p.nombre = 'Rapidógrafo Edding';

-- ---------------------------------------------------------------------
-- Escolar > Corrección y afilado > Borradores
-- ---------------------------------------------------------------------
INSERT INTO productos (nombre, descripcion, atributos)
SELECT d.nombre, d.descripcion, d.atributos
FROM (
  SELECT 'Borrador nata' AS nombre, 'Borrador de nata tradicional.' AS descripcion,
         '{"tipo":"nata"}' AS atributos
  UNION ALL SELECT 'Borrador miga de pan',           'Borrador tipo miga de pan, suave con el papel.', '{"tipo":"miga_de_pan"}'
  UNION ALL SELECT 'Borrador retráctil',             'Borrador con mecanismo retráctil.',              '{"tipo":"retractil"}'
  UNION ALL SELECT 'Borrador barra larga',           'Borrador en barra larga.',                        '{"tipo":"barra_larga"}'
  UNION ALL SELECT 'Borrador para tablero acrílico', 'Borrador diseñado para tableros acrílicos.',     '{"uso":"tablero_acrilico"}'
) AS d
LEFT JOIN productos p ON p.nombre = d.nombre
WHERE p.id IS NULL;

INSERT IGNORE INTO producto_categoria (producto_id, categoria_id)
SELECT p.id, c.id
FROM (
  SELECT 'Borrador nata' AS producto,                  'Borradores' AS categoria
  UNION ALL SELECT 'Borrador miga de pan',              'Borradores'
  UNION ALL SELECT 'Borrador retráctil',                'Borradores'
  UNION ALL SELECT 'Borrador barra larga',              'Borradores'
  UNION ALL SELECT 'Borrador para tablero acrílico',    'Borradores'
) AS r
JOIN productos p ON p.nombre = r.producto
JOIN categorias c ON c.nombre = r.categoria;

-- ---------------------------------------------------------------------
-- Escolar > Corrección y afilado > Sacapuntas
-- ---------------------------------------------------------------------
INSERT INTO productos (nombre, descripcion, atributos)
SELECT d.nombre, d.descripcion, d.atributos
FROM (
  SELECT 'Sacapuntas un hueco con depósito' AS nombre,
         'Sacapuntas de un hueco con depósito.' AS descripcion,
         '{"huecos":1,"con_deposito":true}' AS atributos
  UNION ALL SELECT 'Sacapuntas doble hueco con depósito',
                    'Sacapuntas de doble hueco con depósito.',
                    '{"huecos":2,"con_deposito":true}'
  UNION ALL SELECT 'Sacapuntas metálico sin depósito',
                    'Sacapuntas metálico sin depósito.',
                    '{"material":"metal","con_deposito":false}'
  UNION ALL SELECT 'Sacapuntas plástico sin depósito',
                    'Sacapuntas plástico sin depósito.',
                    '{"material":"plastico","con_deposito":false}'
) AS d
LEFT JOIN productos p ON p.nombre = d.nombre
WHERE p.id IS NULL;

INSERT IGNORE INTO producto_categoria (producto_id, categoria_id)
SELECT p.id, c.id
FROM (
  SELECT 'Sacapuntas un hueco con depósito' AS producto,      'Sacapuntas' AS categoria
  UNION ALL SELECT 'Sacapuntas doble hueco con depósito',     'Sacapuntas'
  UNION ALL SELECT 'Sacapuntas metálico sin depósito',        'Sacapuntas'
  UNION ALL SELECT 'Sacapuntas plástico sin depósito',        'Sacapuntas'
) AS r
JOIN productos p ON p.nombre = r.producto
JOIN categorias c ON c.nombre = r.categoria;

-- ---------------------------------------------------------------------
-- Escolar > Corrección y afilado > Correctores
-- ---------------------------------------------------------------------
INSERT INTO productos (nombre, descripcion, atributos)
SELECT d.nombre, d.descripcion, d.atributos
FROM (
  SELECT 'Corrector líquido' AS nombre,
         'Corrector en presentación líquida.' AS descripcion,
         '{"tipo":"liquido"}' AS atributos
  UNION ALL SELECT 'Corrector en cinta',
                    'Corrector en cinta con dispensador.',
                    '{"tipo":"cinta"}'
) AS d
LEFT JOIN productos p ON p.nombre = d.nombre
WHERE p.id IS NULL;

INSERT IGNORE INTO producto_categoria (producto_id, categoria_id)
SELECT p.id, c.id
FROM (
  SELECT 'Corrector líquido' AS producto, 'Correctores' AS categoria
  UNION ALL SELECT 'Corrector en cinta',  'Correctores'
) AS r
JOIN productos p ON p.nombre = r.producto
JOIN categorias c ON c.nombre = r.categoria;

-- =====================================================================
-- Escolar > Marcación > Marcadores
-- =====================================================================
INSERT INTO productos (nombre, descripcion, atributos)
SELECT d.nombre, d.descripcion, d.atributos FROM (
  SELECT 'Marcador Sharpie Fine' AS nombre,
         'Marcador permanente Sharpie punta fina, varios colores.' AS descripcion,
         '{"marca":"Sharpie","tipo_punta":"fine","colores":["rojo","azul","negro","verde","rosado","morado"]}' AS atributos
  UNION ALL SELECT 'Marcador para tablero',
                    'Marcador borrable para tablero acrílico.',
                    '{"uso":"tablero"}'
  UNION ALL SELECT 'Marcador para cartelera',
                    'Marcador para cartelera, varios colores.',
                    '{"uso":"cartelera"}'
  UNION ALL SELECT 'Marcador de vinilo',
                    'Marcador con tinta tipo vinilo.',
                    '{"base":"vinilo"}'
  UNION ALL SELECT 'Marcador borrable y recargable',
                    'Marcador borrable con sistema recargable.',
                    '{"borrable":true,"recargable":true}'
) AS d WHERE NOT EXISTS (SELECT 1 FROM productos p WHERE p.nombre = d.nombre);

INSERT IGNORE INTO producto_categoria (producto_id, categoria_id)
SELECT p.id, c.id FROM (
  SELECT 'Marcador Sharpie Fine' AS p UNION ALL SELECT 'Marcador para tablero'
  UNION ALL SELECT 'Marcador para cartelera' UNION ALL SELECT 'Marcador de vinilo'
  UNION ALL SELECT 'Marcador borrable y recargable'
) AS r JOIN productos p ON p.nombre = r.p JOIN categorias c ON c.nombre = 'Marcadores';

-- =====================================================================
-- Escolar > Marcación > Resaltadores
-- =====================================================================
INSERT INTO productos (nombre, descripcion, atributos)
SELECT d.nombre, d.descripcion, d.atributos FROM (
  SELECT 'Resaltador fluorescente'    AS nombre, 'Resaltador fluorescente, varios colores.' AS descripcion, '{"tipo":"fluorescente"}' AS atributos
  UNION ALL SELECT 'Resaltador pastel','Resaltador tonos pastel.',                        '{"tipo":"pastel"}'
) AS d WHERE NOT EXISTS (SELECT 1 FROM productos p WHERE p.nombre = d.nombre);

INSERT IGNORE INTO producto_categoria (producto_id, categoria_id)
SELECT p.id, c.id FROM (
  SELECT 'Resaltador fluorescente' AS p UNION ALL SELECT 'Resaltador pastel'
) AS r JOIN productos p ON p.nombre = r.p JOIN categorias c ON c.nombre = 'Resaltadores';

-- =====================================================================
-- Escolar > Geometría
-- =====================================================================
INSERT INTO productos (nombre, descripcion, atributos)
SELECT d.nombre, d.descripcion, d.atributos FROM (
  SELECT 'Juego de escuadras'      AS nombre, 'Juego de escuadras (45° y 60°).' AS descripcion, '{"tipo":"juego","angulos":["45","60"]}' AS atributos
  UNION ALL SELECT 'Escuadra individual',    'Escuadra individual, varios ángulos.',       '{"tipo":"individual"}'
  UNION ALL SELECT 'Regla 50 cm',            'Regla de 50 cm.',                             '{"longitud":"50cm"}'
  UNION ALL SELECT 'Regla 100 cm',           'Regla de 100 cm.',                            '{"longitud":"100cm"}'
  UNION ALL SELECT 'Regla T',                'Regla en T para dibujo técnico.',             '{"tipo":"T"}'
  UNION ALL SELECT 'Plantilla de mapas',     'Plantilla para dibujar mapas.',               '{"uso":"mapas"}'
  UNION ALL SELECT 'Plantilla de círculos',  'Plantilla con círculos de varios tamaños.',   '{"uso":"circulos"}'
  UNION ALL SELECT 'Curvígrafo',             'Curvígrafo para trazado de curvas.',          '{"uso":"curvas"}'
) AS d WHERE NOT EXISTS (SELECT 1 FROM productos p WHERE p.nombre = d.nombre);

INSERT IGNORE INTO producto_categoria (producto_id, categoria_id)
SELECT p.id, c.id FROM (
  SELECT 'Juego de escuadras' AS p UNION ALL SELECT 'Escuadra individual'
  UNION ALL SELECT 'Regla 50 cm' UNION ALL SELECT 'Regla 100 cm'
  UNION ALL SELECT 'Regla T' UNION ALL SELECT 'Plantilla de mapas'
  UNION ALL SELECT 'Plantilla de círculos' UNION ALL SELECT 'Curvígrafo'
) AS r JOIN productos p ON p.nombre = r.p JOIN categorias c ON c.nombre = 'Geometría';

-- =====================================================================
-- Escolar > Colores y crayones
-- =====================================================================
INSERT INTO productos (nombre, descripcion, atributos)
SELECT d.nombre, d.descripcion, d.atributos FROM (
  SELECT 'Colores jumbo preescolar' AS nombre,
         'Colores jumbo para preescolar, varias marcas.' AS descripcion,
         '{"tipo":"jumbo","uso":"preescolar","marcas":["Marfil","Primavera","Kores"]}' AS atributos
  UNION ALL SELECT 'Colores x12',
                    'Colores x12, una o doble punta, varias marcas.',
                    '{"cantidad":12,"puntas":[1,2],"marcas":["Marfil","Qnota","Norma"]}'
  UNION ALL SELECT 'Crayones gruesos',
                    'Crayones gruesos para niños.',
                    '{"grosor":"grueso"}'
  UNION ALL SELECT 'Crayones pequeños',
                    'Crayones delgados.',
                    '{"grosor":"fino"}'
) AS d WHERE NOT EXISTS (SELECT 1 FROM productos p WHERE p.nombre = d.nombre);

INSERT IGNORE INTO producto_categoria (producto_id, categoria_id)
SELECT p.id, c.id FROM (
  SELECT 'Colores jumbo preescolar' AS p UNION ALL SELECT 'Colores x12'
  UNION ALL SELECT 'Crayones gruesos' UNION ALL SELECT 'Crayones pequeños'
) AS r JOIN productos p ON p.nombre = r.p JOIN categorias c ON c.nombre = 'Colores y crayones';

-- =====================================================================
-- Escolar > Plumones jumbo
-- =====================================================================
INSERT INTO productos (nombre, descripcion, atributos)
SELECT d.nombre, d.descripcion, d.atributos FROM (
  SELECT 'Plumón jumbo lavable'      AS nombre, 'Plumón jumbo para niños, tinta lavable.' AS descripcion, '{"tipo":"lavable"}' AS atributos
  UNION ALL SELECT 'Plumón jumbo doble punta', 'Plumón jumbo con doble punta.',          '{"puntas":2}'
  UNION ALL SELECT 'Plumón jumbo una punta Norma','Plumón jumbo una punta marca Norma.', '{"marca":"Norma","puntas":1}'
  UNION ALL SELECT 'Plumón jumbo una punta Grafitos','Plumón jumbo una punta marca Grafitos.','{"marca":"Grafitos","puntas":1}'
) AS d WHERE NOT EXISTS (SELECT 1 FROM productos p WHERE p.nombre = d.nombre);

INSERT IGNORE INTO producto_categoria (producto_id, categoria_id)
SELECT p.id, c.id FROM (
  SELECT 'Plumón jumbo lavable' AS p UNION ALL SELECT 'Plumón jumbo doble punta'
  UNION ALL SELECT 'Plumón jumbo una punta Norma' UNION ALL SELECT 'Plumón jumbo una punta Grafitos'
) AS r JOIN productos p ON p.nombre = r.p JOIN categorias c ON c.nombre = 'Plumones jumbo';

-- =====================================================================
-- Escolar > Cuadernos y libretas
-- =====================================================================
-- Cosidos (50 y 100 hojas, varios rayados)
INSERT INTO productos (nombre, descripcion, atributos)
SELECT d.nombre, d.descripcion, d.atributos FROM (
  SELECT 'Cuaderno cosido 50 hojas rayado'          AS nombre, 'Cuaderno cosido 50 hojas, rayado.' AS descripcion, '{"tipo":"cosido","hojas":50,"rayado":"rayado"}' AS atributos
  UNION ALL SELECT 'Cuaderno cosido 100 hojas rayado',          'Cuaderno cosido 100 hojas, rayado.',          '{"tipo":"cosido","hojas":100,"rayado":"rayado"}'
  UNION ALL SELECT 'Cuaderno cosido 50 hojas cuadriculado',     'Cuaderno cosido 50 hojas, cuadriculado.',     '{"tipo":"cosido","hojas":50,"rayado":"cuadriculado"}'
  UNION ALL SELECT 'Cuaderno cosido 100 hojas cuadriculado',    'Cuaderno cosido 100 hojas, cuadriculado.',    '{"tipo":"cosido","hojas":100,"rayado":"cuadriculado"}'
  UNION ALL SELECT 'Cuaderno cosido 50 hojas doble línea',      'Cuaderno cosido 50 hojas, doble línea.',      '{"tipo":"cosido","hojas":50,"rayado":"doble_linea"}'
  UNION ALL SELECT 'Cuaderno cosido 100 hojas doble línea',     'Cuaderno cosido 100 hojas, doble línea.',     '{"tipo":"cosido","hojas":100,"rayado":"doble_linea"}'
  UNION ALL SELECT 'Cuaderno cosido 50 hojas cuadros grandes',  'Cuaderno cosido 50 hojas, cuadros grandes.',  '{"tipo":"cosido","hojas":50,"rayado":"cuadros_grandes"}'
  UNION ALL SELECT 'Cuaderno cosido 100 hojas cuadros grandes', 'Cuaderno cosido 100 hojas, cuadros grandes.', '{"tipo":"cosido","hojas":100,"rayado":"cuadros_grandes"}'
  UNION ALL SELECT 'Cuaderno cosido preescolar A',              'Cuaderno cosido preescolar, letra A.',        '{"tipo":"cosido","uso":"preescolar","letra":"A"}'
  UNION ALL SELECT 'Cuaderno cosido preescolar B',              'Cuaderno cosido preescolar, letra B.',        '{"tipo":"cosido","uso":"preescolar","letra":"B"}'
  UNION ALL SELECT 'Cuaderno cosido preescolar C',              'Cuaderno cosido preescolar, letra C.',        '{"tipo":"cosido","uso":"preescolar","letra":"C"}'
  UNION ALL SELECT 'Cuaderno cosido preescolar D',              'Cuaderno cosido preescolar, letra D.',        '{"tipo":"cosido","uso":"preescolar","letra":"D"}'
) AS d WHERE NOT EXISTS (SELECT 1 FROM productos p WHERE p.nombre = d.nombre);

INSERT IGNORE INTO producto_categoria (producto_id, categoria_id)
SELECT p.id, c.id FROM productos p JOIN categorias c ON c.nombre = 'Cosidos'
WHERE p.nombre LIKE 'Cuaderno cosido %';

-- Anillados
INSERT INTO productos (nombre, descripcion, atributos)
SELECT d.nombre, d.descripcion, d.atributos FROM (
  SELECT 'Cuaderno anillado pequeño' AS nombre, 'Cuaderno anillado tamaño pequeño.' AS descripcion, '{"tipo":"anillado","tamano":"pequeno"}' AS atributos
  UNION ALL SELECT 'Cuaderno anillado grande','Cuaderno anillado tamaño grande.','{"tipo":"anillado","tamano":"grande"}'
  UNION ALL SELECT 'Libreta anillada',        'Libreta con anillado metálico.',  '{"tipo":"anillado"}'
) AS d WHERE NOT EXISTS (SELECT 1 FROM productos p WHERE p.nombre = d.nombre);

INSERT IGNORE INTO producto_categoria (producto_id, categoria_id)
SELECT p.id, c.id FROM (
  SELECT 'Cuaderno anillado pequeño' AS p UNION ALL SELECT 'Cuaderno anillado grande'
  UNION ALL SELECT 'Libreta anillada'
) AS r JOIN productos p ON p.nombre = r.p JOIN categorias c ON c.nombre = 'Anillados';

-- Agendas
INSERT INTO productos (nombre, descripcion, atributos)
SELECT d.nombre, d.descripcion, d.atributos FROM (
  SELECT 'Agenda 5 materias pequeño' AS nombre, 'Agenda 5 materias tamaño pequeño.' AS descripcion, '{"materias":5,"tamano":"pequeno"}' AS atributos
  UNION ALL SELECT 'Agenda 5 materias grande','Agenda 5 materias tamaño grande.','{"materias":5,"tamano":"grande"}'
  UNION ALL SELECT 'Agenda 7 materias pequeño','Agenda 7 materias tamaño pequeño.','{"materias":7,"tamano":"pequeno"}'
  UNION ALL SELECT 'Agenda 7 materias grande', 'Agenda 7 materias tamaño grande.', '{"materias":7,"tamano":"grande"}'
) AS d WHERE NOT EXISTS (SELECT 1 FROM productos p WHERE p.nombre = d.nombre);

INSERT IGNORE INTO producto_categoria (producto_id, categoria_id)
SELECT p.id, c.id FROM productos p JOIN categorias c ON c.nombre = 'Agendas'
WHERE p.nombre LIKE 'Agenda %';

-- Mininotas
INSERT INTO productos (nombre, descripcion, atributos)
SELECT 'Mininota anillada', 'Mininota con anillado metálico.', '{"tipo":"anillada"}'
WHERE NOT EXISTS (SELECT 1 FROM productos WHERE nombre = 'Mininota anillada');

INSERT IGNORE INTO producto_categoria (producto_id, categoria_id)
SELECT p.id, c.id FROM productos p JOIN categorias c ON c.nombre = 'Mininotas'
WHERE p.nombre = 'Mininota anillada';

-- Música
INSERT INTO productos (nombre, descripcion, atributos)
SELECT 'Cuaderno para música', 'Cuaderno con pentagramas para música.', '{"tipo":"musica"}'
WHERE NOT EXISTS (SELECT 1 FROM productos WHERE nombre = 'Cuaderno para música');

INSERT IGNORE INTO producto_categoria (producto_id, categoria_id)
SELECT p.id, c.id FROM productos p JOIN categorias c ON c.nombre = 'Música'
WHERE p.nombre = 'Cuaderno para música';

-- =====================================================================
-- Escolar > Libros y lectura
-- =====================================================================
INSERT INTO productos (nombre, descripcion, atributos)
SELECT d.nombre, d.descripcion, d.atributos FROM (
  SELECT 'Obra literaria' AS nombre, 'Obras literarias varias.' AS descripcion, '{"tipo":"literatura"}' AS atributos
  UNION ALL SELECT 'Diccionario inglés económico', 'Diccionario inglés-español económico.',            '{"idioma":"ingles","gama":"economica"}'
  UNION ALL SELECT 'Diccionario inglés Norma',     'Diccionario inglés-español marca Norma.',          '{"idioma":"ingles","marca":"Norma"}'
  UNION ALL SELECT 'Diccionario español económico','Diccionario de español económico.',                '{"idioma":"espanol","gama":"economica"}'
  UNION ALL SELECT 'Diccionario español Norma',    'Diccionario de español marca Norma.',              '{"idioma":"espanol","marca":"Norma"}'
  UNION ALL SELECT 'Cartilla Nacho',               'Cartilla de lectoescritura Nacho.',                '{"tipo":"cartilla"}'
  UNION ALL SELECT 'Sopas de letras',              'Libro de sopas de letras.',                        '{"tipo":"pasatiempo"}'
  UNION ALL SELECT 'Libro para colorear',          'Libro con dibujos para colorear.',                 '{"tipo":"colorear"}'
  UNION ALL SELECT 'Mandalas para colorear',       'Libro de mandalas para colorear.',                 '{"tipo":"mandalas"}'
  UNION ALL SELECT 'Sudokus',                      'Libro de sudokus.',                                '{"tipo":"sudoku"}'
  UNION ALL SELECT 'Atlas de Colombia',            'Atlas geográfico de Colombia.',                    '{"tipo":"atlas","pais":"Colombia"}'
  UNION ALL SELECT 'Atlas universal',              'Atlas geográfico universal.',                      '{"tipo":"atlas","alcance":"universal"}'
) AS d WHERE NOT EXISTS (SELECT 1 FROM productos p WHERE p.nombre = d.nombre);

INSERT IGNORE INTO producto_categoria (producto_id, categoria_id)
SELECT p.id, c.id FROM (
  SELECT 'Obra literaria' AS p,                    'Obras literarias' AS c
  UNION ALL SELECT 'Diccionario inglés económico', 'Diccionarios'
  UNION ALL SELECT 'Diccionario inglés Norma',     'Diccionarios'
  UNION ALL SELECT 'Diccionario español económico','Diccionarios'
  UNION ALL SELECT 'Diccionario español Norma',    'Diccionarios'
  UNION ALL SELECT 'Cartilla Nacho',               'Cartilla Nacho'
  UNION ALL SELECT 'Sopas de letras',              'Pasatiempos'
  UNION ALL SELECT 'Libro para colorear',          'Pasatiempos'
  UNION ALL SELECT 'Mandalas para colorear',       'Pasatiempos'
  UNION ALL SELECT 'Sudokus',                      'Pasatiempos'
  UNION ALL SELECT 'Atlas de Colombia',            'Atlas'
  UNION ALL SELECT 'Atlas universal',              'Atlas'
) AS r JOIN productos p ON p.nombre = r.p JOIN categorias c ON c.nombre = r.c;

-- =====================================================================
-- Escolar > Pegantes y cintas > Pegantes
-- =====================================================================
INSERT INTO productos (nombre, descripcion, atributos)
SELECT d.nombre, d.descripcion, d.atributos FROM (
  SELECT 'Pegante líquido Sipega 250 ml' AS nombre, 'Pegante líquido Sipega 250 ml.' AS descripcion, '{"marca":"Sipega","tipo":"liquido","volumen":"250ml"}' AS atributos
  UNION ALL SELECT 'Pegante líquido Sipega 125 ml',    'Pegante líquido Sipega 125 ml.',    '{"marca":"Sipega","tipo":"liquido","volumen":"125ml"}'
  UNION ALL SELECT 'Pegante líquido Sipega 40 ml',     'Pegante líquido Sipega 40 ml.',     '{"marca":"Sipega","tipo":"liquido","volumen":"40ml"}'
  UNION ALL SELECT 'Barra Sipega 15 g',                'Barra de pegante Sipega 15 g.',     '{"marca":"Sipega","tipo":"barra","peso":"15g"}'
  UNION ALL SELECT 'Barra Sipega 25 g',                'Barra de pegante Sipega 25 g.',     '{"marca":"Sipega","tipo":"barra","peso":"25g"}'
  UNION ALL SELECT 'Barra Sipega 40 g',                'Barra de pegante Sipega 40 g.',     '{"marca":"Sipega","tipo":"barra","peso":"40g"}'
  UNION ALL SELECT 'Silicona en barra delgada',        'Silicona en barra delgada.',        '{"tipo":"silicona","formato":"barra","grosor":"delgada"}'
  UNION ALL SELECT 'Silicona en barra gruesa',         'Silicona en barra gruesa.',         '{"tipo":"silicona","formato":"barra","grosor":"gruesa"}'
  UNION ALL SELECT 'Silicona líquida 30 ml',           'Silicona líquida 30 ml.',           '{"tipo":"silicona","formato":"liquida","volumen":"30ml"}'
  UNION ALL SELECT 'Silicona líquida 60 ml',           'Silicona líquida 60 ml.',           '{"tipo":"silicona","formato":"liquida","volumen":"60ml"}'
  UNION ALL SELECT 'Silicona líquida 100 ml',          'Silicona líquida 100 ml.',          '{"tipo":"silicona","formato":"liquida","volumen":"100ml"}'
  UNION ALL SELECT 'Silicona líquida 250 ml',          'Silicona líquida 250 ml.',          '{"tipo":"silicona","formato":"liquida","volumen":"250ml"}'
  UNION ALL SELECT 'Pegante instantáneo',              'Pegante instantáneo (tipo cianoacrilato).',    '{"tipo":"instantaneo"}'
  UNION ALL SELECT 'Pegante Boxer pequeño',            'Pegante Boxer presentación pequeña.',          '{"marca":"Boxer","tamano":"pequeno"}'
  UNION ALL SELECT 'Pegante transparente',             'Pegante transparente multipropósito.',         '{"tipo":"transparente"}'
  UNION ALL SELECT 'Pegante para madera',              'Pegante especial para madera.',                '{"uso":"madera"}'
) AS d WHERE NOT EXISTS (SELECT 1 FROM productos p WHERE p.nombre = d.nombre);

INSERT IGNORE INTO producto_categoria (producto_id, categoria_id)
SELECT p.id, c.id FROM productos p JOIN categorias c ON c.nombre = 'Pegantes'
WHERE p.nombre IN (
  'Pegante líquido Sipega 250 ml','Pegante líquido Sipega 125 ml','Pegante líquido Sipega 40 ml',
  'Barra Sipega 15 g','Barra Sipega 25 g','Barra Sipega 40 g',
  'Silicona en barra delgada','Silicona en barra gruesa',
  'Silicona líquida 30 ml','Silicona líquida 60 ml','Silicona líquida 100 ml','Silicona líquida 250 ml',
  'Pegante instantáneo','Pegante Boxer pequeño','Pegante transparente','Pegante para madera'
);

-- =====================================================================
-- Escolar > Pegantes y cintas > Cintas
-- =====================================================================
INSERT INTO productos (nombre, descripcion, atributos)
SELECT d.nombre, d.descripcion, d.atributos FROM (
  SELECT 'Cinta de enmascarar 12 mm' AS nombre, 'Cinta de enmascarar 12 mm.' AS descripcion, '{"tipo":"enmascarar","ancho":"12mm"}' AS atributos
  UNION ALL SELECT 'Cinta de enmascarar 18 mm',   'Cinta de enmascarar 18 mm.',   '{"tipo":"enmascarar","ancho":"18mm"}'
  UNION ALL SELECT 'Cinta de enmascarar 24 mm',   'Cinta de enmascarar 24 mm.',   '{"tipo":"enmascarar","ancho":"24mm"}'
  UNION ALL SELECT 'Cinta transparente 20 m',     'Cinta transparente 20 m.',     '{"tipo":"transparente","largo":"20m"}'
  UNION ALL SELECT 'Cinta transparente 40 m',     'Cinta transparente 40 m.',     '{"tipo":"transparente","largo":"40m"}'
  UNION ALL SELECT 'Cinta transparente 100 m',    'Cinta transparente 100 m.',    '{"tipo":"transparente","largo":"100m"}'
  UNION ALL SELECT 'Dispensador cinta delgada 20 m','Dispensador con cinta delgada 20 m.','{"tipo":"dispensador","largo":"20m"}'
  UNION ALL SELECT 'Dispensador cinta delgada 40 m','Dispensador con cinta delgada 40 m.','{"tipo":"dispensador","largo":"40m"}'
  UNION ALL SELECT 'Cintas pequeñas pegantes',       'Cintas pequeñas adhesivas varias.',   '{"tipo":"pegante","tamano":"pequeno"}'
) AS d WHERE NOT EXISTS (SELECT 1 FROM productos p WHERE p.nombre = d.nombre);

INSERT IGNORE INTO producto_categoria (producto_id, categoria_id)
SELECT p.id, c.id FROM productos p JOIN categorias c ON c.nombre = 'Cintas'
WHERE p.nombre LIKE 'Cinta%' OR p.nombre LIKE 'Dispensador%';

-- =====================================================================
-- Escolar > Papeles y cartones > Papel
-- =====================================================================
INSERT INTO productos (nombre, descripcion, atributos)
SELECT d.nombre, d.descripcion, d.atributos FROM (
  SELECT 'Papel seda'        AS nombre, 'Papel seda, varios colores (octavo y pliego).' AS descripcion, '{"tipo":"seda","colores":"varios","tamanos":["octavo","pliego"]}' AS atributos
  UNION ALL SELECT 'Papel silueta',    'Papel silueta, varios colores (octavo y pliego).','{"tipo":"silueta","colores":"varios","tamanos":["octavo","pliego"]}'
  UNION ALL SELECT 'Papel bond pliego','Papel bond tamaño pliego.',                       '{"tipo":"bond","tamano":"pliego"}'
  UNION ALL SELECT 'Papel craft pliego','Papel craft tamaño pliego.',                     '{"tipo":"craft","tamano":"pliego"}'
  UNION ALL SELECT 'Papel fotográfico', 'Papel fotográfico para impresión.',              '{"tipo":"fotografico"}'
  UNION ALL SELECT 'Papel fotográfico adhesivo','Papel fotográfico adhesivo.',            '{"tipo":"fotografico","adhesivo":true}'
  UNION ALL SELECT 'Papel opalina',     'Papel opalina (carta y oficio).',                 '{"tipo":"opalina","tamanos":["carta","oficio"]}'
  UNION ALL SELECT 'Papel adhesivo',    'Papel adhesivo (carta y oficio).',                '{"tipo":"adhesivo","tamanos":["carta","oficio"]}'
  UNION ALL SELECT 'Papel crepe',       'Papel crepe, varios colores.',                    '{"tipo":"crepe","colores":"varios"}'
  UNION ALL SELECT 'Papel celofán',     'Papel celofán unicolor, tornasol y estampado.',   '{"tipo":"celofan","variedades":["unicolor","tornasol","estampado"]}'
) AS d WHERE NOT EXISTS (SELECT 1 FROM productos p WHERE p.nombre = d.nombre);

INSERT IGNORE INTO producto_categoria (producto_id, categoria_id)
SELECT p.id, c.id FROM productos p JOIN categorias c ON c.nombre = 'Papel'
WHERE p.nombre LIKE 'Papel %';

-- =====================================================================
-- Escolar > Papeles y cartones > Cartulinas
-- =====================================================================
INSERT INTO productos (nombre, descripcion, atributos)
SELECT d.nombre, d.descripcion, d.atributos FROM (
  SELECT 'Cartulina bristol' AS nombre, 'Cartulina bristol (verde, amarilla, rosada, azul, blanca).' AS descripcion, '{"tipo":"bristol","colores":["verde","amarilla","rosada","azul","blanca"],"tamanos":["octavo","cuarto","medio_pliego","pliego"]}' AS atributos
  UNION ALL SELECT 'Cartulina negra',         'Cartulina negra.',                                    '{"tipo":"negra","tamanos":["octavo","medio_pliego","pliego"]}'
  UNION ALL SELECT 'Cartulina fluorescente',  'Cartulina fluorescente.',                             '{"tipo":"fluorescente","tamanos":["octavo","medio_pliego"]}'
  UNION ALL SELECT 'Cartulina escolar',       'Cartulina escolar tonos fuertes.',                    '{"tipo":"escolar","tonos":"fuertes","tamanos":["octavo","medio_pliego"]}'
) AS d WHERE NOT EXISTS (SELECT 1 FROM productos p WHERE p.nombre = d.nombre);

INSERT IGNORE INTO producto_categoria (producto_id, categoria_id)
SELECT p.id, c.id FROM productos p JOIN categorias c ON c.nombre = 'Cartulinas'
WHERE p.nombre LIKE 'Cartulina %';

-- =====================================================================
-- Escolar > Papeles y cartones > Cartones
-- =====================================================================
INSERT INTO productos (nombre, descripcion, atributos)
SELECT d.nombre, d.descripcion, d.atributos FROM (
  SELECT 'Cartón paja'      AS nombre, 'Cartón paja (octavo, cuarto, medio pliego, pliego).' AS descripcion, '{"tipo":"paja","tamanos":["octavo","cuarto","medio_pliego","pliego"]}' AS atributos
  UNION ALL SELECT 'Cartón piedra','Cartón piedra (octavo, cuarto, medio pliego, pliego).','{"tipo":"piedra","tamanos":["octavo","cuarto","medio_pliego","pliego"]}'
  UNION ALL SELECT 'Cartón cartón','Cartón cartón tamaño pliego.',                        '{"tipo":"carton","tamano":"pliego"}'
  UNION ALL SELECT 'Cartón cartulina','Cartón cartulina tamaño pliego.',                  '{"tipo":"cartulina","tamano":"pliego"}'
) AS d WHERE NOT EXISTS (SELECT 1 FROM productos p WHERE p.nombre = d.nombre);

INSERT IGNORE INTO producto_categoria (producto_id, categoria_id)
SELECT p.id, c.id FROM productos p JOIN categorias c ON c.nombre = 'Cartones'
WHERE p.nombre LIKE 'Cartón %';

-- =====================================================================
-- Escolar > Papeles y cartones > Blocs
-- =====================================================================
INSERT INTO productos (nombre, descripcion, atributos)
SELECT d.nombre, d.descripcion, d.atributos FROM (
  SELECT 'Bloc blanco rayado'      AS nombre, 'Bloc blanco rayado (carta, oficio, media carta).' AS descripcion, '{"tipo":"blanco","rayado":"rayado","tamanos":["carta","oficio","media_carta"]}' AS atributos
  UNION ALL SELECT 'Bloc blanco cuadriculado','Bloc blanco cuadriculado (carta, oficio, media carta).','{"tipo":"blanco","rayado":"cuadriculado","tamanos":["carta","oficio","media_carta"]}'
  UNION ALL SELECT 'Bloc Iris',               'Bloc Iris (carta y oficio).',                          '{"tipo":"iris","tamanos":["carta","oficio"]}'
  UNION ALL SELECT 'Bloc milimetrado',        'Bloc de papel milimetrado.',                           '{"tipo":"milimetrado"}'
  UNION ALL SELECT 'Bloc de planchas',        'Bloc con planchas.',                                   '{"tipo":"planchas"}'
) AS d WHERE NOT EXISTS (SELECT 1 FROM productos p WHERE p.nombre = d.nombre);

INSERT IGNORE INTO producto_categoria (producto_id, categoria_id)
SELECT p.id, c.id FROM productos p JOIN categorias c ON c.nombre = 'Blocs'
WHERE p.nombre LIKE 'Bloc %';

-- =====================================================================
-- Escolar > Papeles y cartones > Hojas
-- =====================================================================
INSERT INTO productos (nombre, descripcion, atributos)
SELECT d.nombre, d.descripcion, d.atributos FROM (
  SELECT 'Hojas de examen rayadas'        AS nombre, 'Hojas de examen rayadas.' AS descripcion, '{"tipo":"examen","rayado":"rayado"}' AS atributos
  UNION ALL SELECT 'Hojas de examen cuadriculadas','Hojas de examen cuadriculadas.','{"tipo":"examen","rayado":"cuadriculado"}'
  UNION ALL SELECT 'Hojas de plancha',              'Hojas de plancha.',             '{"tipo":"plancha"}'
  UNION ALL SELECT 'Hojas de acetato',              'Hojas de acetato transparente.', '{"tipo":"acetato"}'
  UNION ALL SELECT 'Hojas para folder cuadriculadas','Hojas para folder, cuadriculadas.','{"tipo":"folder","rayado":"cuadriculado"}'
) AS d WHERE NOT EXISTS (SELECT 1 FROM productos p WHERE p.nombre = d.nombre);

INSERT IGNORE INTO producto_categoria (producto_id, categoria_id)
SELECT p.id, c.id FROM productos p JOIN categorias c ON c.nombre = 'Hojas'
WHERE p.nombre LIKE 'Hojas %';

-- =====================================================================
-- Escolar > Papeles y cartones > Icopor
-- =====================================================================
INSERT INTO productos (nombre, descripcion, atributos)
SELECT d.nombre, d.descripcion, d.atributos FROM (
  SELECT 'Bolas de icopor'     AS nombre, 'Bolas de icopor tamaños 1 a 18.' AS descripcion, '{"tipo":"bolas","tamanos":"1-18"}' AS atributos
  UNION ALL SELECT 'Lámina de icopor 50x50','Lámina de icopor 50x50 cm, varios grosores.','{"tipo":"lamina","medidas":"50x50","grosores":"varios"}'
  UNION ALL SELECT 'Lámina de icopor 1x1 m','Lámina de icopor 1x1 m, varios grosores.',  '{"tipo":"lamina","medidas":"1x1m","grosores":"varios"}'
) AS d WHERE NOT EXISTS (SELECT 1 FROM productos p WHERE p.nombre = d.nombre);

INSERT IGNORE INTO producto_categoria (producto_id, categoria_id)
SELECT p.id, c.id FROM productos p JOIN categorias c ON c.nombre = 'Icopor'
WHERE p.nombre LIKE '%icopor%';

-- =====================================================================
-- Escolar > Didácticos > Tablas de punzado
-- =====================================================================
INSERT INTO productos (nombre, descripcion, atributos)
SELECT 'Tabla de punzado', 'Tabla de punzado para trabajos manuales.', '{"tipo":"punzado"}'
WHERE NOT EXISTS (SELECT 1 FROM productos WHERE nombre = 'Tabla de punzado');

INSERT IGNORE INTO producto_categoria (producto_id, categoria_id)
SELECT p.id, c.id FROM productos p JOIN categorias c ON c.nombre = 'Tablas de punzado'
WHERE p.nombre = 'Tabla de punzado';

-- =====================================================================
-- Escolar > Didácticos > Foamy y escarchas
-- =====================================================================
INSERT INTO productos (nombre, descripcion, atributos)
SELECT d.nombre, d.descripcion, d.atributos FROM (
  SELECT 'Foamy liso'         AS nombre, 'Foamy liso (octavo, pliego, medio pliego).' AS descripcion, '{"tipo":"liso","tamanos":["octavo","pliego","medio_pliego"]}' AS atributos
  UNION ALL SELECT 'Foamy escarchado',  'Foamy escarchado (octavo, medio pliego).',  '{"tipo":"escarchado","tamanos":["octavo","medio_pliego"]}'
  UNION ALL SELECT 'Escarcha en tubo',  'Escarcha en tubo, colores básicos y neón.', '{"formato":"tubo","variantes":["basico","neon"]}'
  UNION ALL SELECT 'Escarcha pesa 120 g','Escarcha en pesa de 120 g, colores variados.','{"formato":"pesa","peso":"120g","colores":"variados"}'
  UNION ALL SELECT 'Foamy moldeable',   'Foamy moldeable.',                          '{"tipo":"moldeable"}'
) AS d WHERE NOT EXISTS (SELECT 1 FROM productos p WHERE p.nombre = d.nombre);

INSERT IGNORE INTO producto_categoria (producto_id, categoria_id)
SELECT p.id, c.id FROM productos p JOIN categorias c ON c.nombre = 'Foamy y escarchas'
WHERE p.nombre LIKE 'Foamy %' OR p.nombre LIKE 'Escarcha %';

-- =====================================================================
-- Escolar > Didácticos > Palos y bajalenguas
-- =====================================================================
INSERT INTO productos (nombre, descripcion, atributos)
SELECT d.nombre, d.descripcion, d.atributos FROM (
  SELECT 'Palo de pincho delgado' AS nombre, 'Palo de pincho delgado.' AS descripcion, '{"tipo":"pincho","grosor":"delgado"}' AS atributos
  UNION ALL SELECT 'Palo de pincho grueso', 'Palo de pincho grueso.', '{"tipo":"pincho","grosor":"grueso"}'
  UNION ALL SELECT 'Palos de paleta',       'Palos de paleta (madera).',      '{"tipo":"paleta"}'
  UNION ALL SELECT 'Bajalenguas',           'Bajalenguas de madera.',         '{"tipo":"bajalenguas"}'
  UNION ALL SELECT 'Palos de balso redondos','Palos de balso redondos.',      '{"material":"balso","forma":"redondo"}'
  UNION ALL SELECT 'Palos de balso cuadrados','Palos de balso cuadrados.',    '{"material":"balso","forma":"cuadrado"}'
) AS d WHERE NOT EXISTS (SELECT 1 FROM productos p WHERE p.nombre = d.nombre);

INSERT IGNORE INTO producto_categoria (producto_id, categoria_id)
SELECT p.id, c.id FROM productos p JOIN categorias c ON c.nombre = 'Palos y bajalenguas'
WHERE p.nombre LIKE 'Palo%' OR p.nombre = 'Bajalenguas';

-- =====================================================================
-- Escolar > Arte > Pinturas
-- =====================================================================
INSERT INTO productos (nombre, descripcion, atributos)
SELECT d.nombre, d.descripcion, d.atributos FROM (
  SELECT 'Vinilo 30 cm³'      AS nombre, 'Vinilo 30 cm³, varios colores.' AS descripcion, '{"tipo":"vinilo","volumen":"30cm3"}' AS atributos
  UNION ALL SELECT 'Vinilo 60 cm³',      'Vinilo 60 cm³, varios colores.',      '{"tipo":"vinilo","volumen":"60cm3"}'
  UNION ALL SELECT 'Vinilo 120 cm³',     'Vinilo 120 cm³, varios colores.',     '{"tipo":"vinilo","volumen":"120cm3"}'
  UNION ALL SELECT 'Vinilo 260 cm³',     'Vinilo 260 cm³, varios colores. Temporada navideña.','{"tipo":"vinilo","volumen":"260cm3","temporada":"navidad"}'
  UNION ALL SELECT 'Vinilo Francoarte',  'Vinilo marca Francoarte.',            '{"tipo":"vinilo","marca":"Francoarte"}'
  UNION ALL SELECT 'Acuarelas',          'Set de acuarelas.',                   '{"tipo":"acuarela"}'
  UNION ALL SELECT 'Tizas pastel',       'Tizas pastel para dibujo.',           '{"tipo":"tiza_pastel"}'
  UNION ALL SELECT 'Paquete de témperas naturales',   'Paquete de témperas tonos naturales.',   '{"tipo":"tempera","gama":"naturales"}'
  UNION ALL SELECT 'Paquete de témperas metalizadas', 'Paquete de témperas tonos metalizados.', '{"tipo":"tempera","gama":"metalizados"}'
  UNION ALL SELECT 'Paquete de témperas neón',        'Paquete de témperas tonos neón.',        '{"tipo":"tempera","gama":"neon"}'
  UNION ALL SELECT 'Tintas para sellos',              'Tintas para sellos, varios colores.',    '{"tipo":"tinta_sellos"}'
  UNION ALL SELECT 'Pintucaritas líquida',            'Pintucaritas en presentación líquida.',  '{"tipo":"pintucaritas","formato":"liquida"}'
  UNION ALL SELECT 'Pintucaritas en crema',           'Pintucaritas en presentación crema.',    '{"tipo":"pintucaritas","formato":"crema"}'
) AS d WHERE NOT EXISTS (SELECT 1 FROM productos p WHERE p.nombre = d.nombre);

INSERT IGNORE INTO producto_categoria (producto_id, categoria_id)
SELECT p.id, c.id FROM productos p JOIN categorias c ON c.nombre = 'Pinturas'
WHERE p.nombre IN (
  'Vinilo 30 cm³','Vinilo 60 cm³','Vinilo 120 cm³','Vinilo 260 cm³','Vinilo Francoarte',
  'Acuarelas','Tizas pastel',
  'Paquete de témperas naturales','Paquete de témperas metalizadas','Paquete de témperas neón',
  'Tintas para sellos','Pintucaritas líquida','Pintucaritas en crema'
);

-- =====================================================================
-- Escolar > Arte > Pinceles y mezcladores
-- =====================================================================
INSERT INTO productos (nombre, descripcion, atributos)
SELECT d.nombre, d.descripcion, d.atributos FROM (
  SELECT 'Kit de pinceles x12' AS nombre, 'Set de 12 pinceles de distintos grosores.' AS descripcion, '{"tipo":"pincel","cantidad":12,"grosores":"varios"}' AS atributos
  UNION ALL SELECT 'Mezcladores (pinceles)','Mezcladores tipo pincel para mezclas.',  '{"tipo":"mezclador"}'
) AS d WHERE NOT EXISTS (SELECT 1 FROM productos p WHERE p.nombre = d.nombre);

INSERT IGNORE INTO producto_categoria (producto_id, categoria_id)
SELECT p.id, c.id FROM productos p JOIN categorias c ON c.nombre = 'Pinceles y mezcladores'
WHERE p.nombre IN ('Kit de pinceles x12','Mezcladores (pinceles)');

-- =====================================================================
-- Escolar > Arte > Lienzos y libros de dibujo
-- =====================================================================
INSERT INTO productos (nombre, descripcion, atributos)
SELECT d.nombre, d.descripcion, d.atributos FROM (
  SELECT 'Lienzo 30x40 cm' AS nombre, 'Lienzo de algodón 30x40 cm, listo para pintar.' AS descripcion, '{"tipo":"lienzo","medidas":"30x40cm"}' AS atributos
  UNION ALL SELECT 'Libros de dibujo','Libros de dibujo artístico.',                   '{"tipo":"libro_dibujo"}'
) AS d WHERE NOT EXISTS (SELECT 1 FROM productos p WHERE p.nombre = d.nombre);

INSERT IGNORE INTO producto_categoria (producto_id, categoria_id)
SELECT p.id, c.id FROM productos p JOIN categorias c ON c.nombre = 'Lienzos y libros de dibujo'
WHERE p.nombre IN ('Lienzo 30x40 cm','Libros de dibujo');

-- =====================================================================
-- Escolar > Arte > Colores y plumones
-- =====================================================================
INSERT INTO productos (nombre, descripcion, atributos)
SELECT d.nombre, d.descripcion, d.atributos FROM (
  SELECT 'Marcadores acrílicos Marfil' AS nombre, 'Marcadores acrílicos marca Marfil.' AS descripcion, '{"tipo":"marcador_acrilico","marca":"Marfil"}' AS atributos
  UNION ALL SELECT 'Marcadores acrílicos Gipao','Marcadores acrílicos marca Gipao.',    '{"tipo":"marcador_acrilico","marca":"Gipao"}'
) AS d WHERE NOT EXISTS (SELECT 1 FROM productos p WHERE p.nombre = d.nombre);

INSERT IGNORE INTO producto_categoria (producto_id, categoria_id)
SELECT p.id, c.id FROM productos p JOIN categorias c ON c.nombre = 'Colores y plumones'
WHERE p.nombre LIKE 'Marcadores acrílicos %';

-- =====================================================================
-- Escolar > Arte > Manualidades
-- =====================================================================
INSERT INTO productos (nombre, descripcion, atributos)
SELECT d.nombre, d.descripcion, d.atributos FROM (
  SELECT 'Plastilina en barra pequeña' AS nombre, 'Plastilina en barra, presentación pequeña.' AS descripcion, '{"tipo":"plastilina","formato":"barra","tamano":"pequeno"}' AS atributos
  UNION ALL SELECT 'Plastilina en barra grande','Plastilina en barra, presentación grande.',  '{"tipo":"plastilina","formato":"barra","tamano":"grande"}'
  UNION ALL SELECT 'Plastilina x9 jumbo',       'Plastilina jumbo, caja x9.',                 '{"tipo":"plastilina","cantidad":9,"formato":"jumbo"}'
  UNION ALL SELECT 'Plastilina x12 jumbo',      'Plastilina jumbo, caja x12.',                '{"tipo":"plastilina","cantidad":12,"formato":"jumbo"}'
  UNION ALL SELECT 'Porcelanicron',             'Porcelanicron para modelado.',               '{"tipo":"porcelanicron"}'
  UNION ALL SELECT 'Filigrana',                 'Filigrama para trabajos manuales.',          '{"tipo":"filigrana"}'
  UNION ALL SELECT 'Chelines metalizados',      'Chelines metalizados.',                      '{"tipo":"chelin","acabado":"metalizado"}'
  UNION ALL SELECT 'Chelines en felpa',         'Chelines en felpa.',                         '{"tipo":"chelin","acabado":"felpa"}'
  UNION ALL SELECT 'Pompones',                  'Pompones decorativos, varios colores.',      '{"tipo":"pompon"}'
  UNION ALL SELECT 'Bolas de icopor decorativas','Bolas de icopor para manualidades.',        '{"tipo":"icopor","uso":"manualidades"}'
) AS d WHERE NOT EXISTS (SELECT 1 FROM productos p WHERE p.nombre = d.nombre);

INSERT IGNORE INTO producto_categoria (producto_id, categoria_id)
SELECT p.id, c.id FROM productos p JOIN categorias c ON c.nombre = 'Manualidades'
WHERE p.nombre IN (
  'Plastilina en barra pequeña','Plastilina en barra grande','Plastilina x9 jumbo','Plastilina x12 jumbo',
  'Porcelanicron','Filigrana','Chelines metalizados','Chelines en felpa','Pompones','Bolas de icopor decorativas'
);

-- =====================================================================
-- Escolar > Arte > Didácticos arte
-- =====================================================================
INSERT INTO productos (nombre, descripcion, atributos)
SELECT d.nombre, d.descripcion, d.atributos FROM (
  SELECT 'Armotodos'      AS nombre, 'Juego didáctico Armotodos.' AS descripcion, '{"tipo":"didactico","subtipo":"armotodos"}' AS atributos
  UNION ALL SELECT 'Tangram',         'Rompecabezas didáctico Tangram.',  '{"tipo":"didactico","subtipo":"tangram"}'
  UNION ALL SELECT 'Rompecabezas',    'Rompecabezas varios.',             '{"tipo":"didactico","subtipo":"rompecabezas"}'
) AS d WHERE NOT EXISTS (SELECT 1 FROM productos p WHERE p.nombre = d.nombre);

INSERT IGNORE INTO producto_categoria (producto_id, categoria_id)
SELECT p.id, c.id FROM productos p JOIN categorias c ON c.nombre = 'Didácticos arte'
WHERE p.nombre IN ('Armotodos','Tangram','Rompecabezas');

-- =====================================================================
-- Archivo y organización > Archivadores
-- =====================================================================
INSERT INTO productos (nombre, descripcion, atributos)
SELECT d.nombre, d.descripcion, d.atributos FROM (
  SELECT 'Archivador 13 bolsillos plástico' AS nombre, 'Archivador plástico 13 bolsillos (media oficio, carta, oficio).' AS descripcion, '{"tipo":"bolsillos","cantidad":13,"material":"plastico","tamanos":["media_oficio","carta","oficio"]}' AS atributos
  UNION ALL SELECT 'Archivador AZ',         'Archivador AZ (carta y oficio).',         '{"tipo":"AZ","tamanos":["carta","oficio"]}'
  UNION ALL SELECT 'Portacarpetas',         'Portacarpetas para archivo.',             '{"tipo":"portacarpetas"}'
) AS d WHERE NOT EXISTS (SELECT 1 FROM productos p WHERE p.nombre = d.nombre);

INSERT IGNORE INTO producto_categoria (producto_id, categoria_id)
SELECT p.id, c.id FROM productos p JOIN categorias c ON c.nombre = 'Archivadores'
WHERE p.nombre LIKE 'Archivador %' OR p.nombre = 'Portacarpetas';

-- =====================================================================
-- Archivo y organización > Folders
-- =====================================================================
INSERT INTO productos (nombre, descripcion, atributos)
SELECT d.nombre, d.descripcion, d.atributos FROM (
  SELECT 'Folder 1 pulgada carta' AS nombre, 'Folder 1 pulgada tamaño carta.' AS descripcion, '{"pulgadas":1,"tamano":"carta"}' AS atributos
  UNION ALL SELECT 'Folder 2 pulgadas oficio','Folder 2 pulgadas tamaño oficio.','{"pulgadas":2,"tamano":"oficio"}'
) AS d WHERE NOT EXISTS (SELECT 1 FROM productos p WHERE p.nombre = d.nombre);

INSERT IGNORE INTO producto_categoria (producto_id, categoria_id)
SELECT p.id, c.id FROM productos p JOIN categorias c ON c.nombre = 'Folders'
WHERE p.nombre LIKE 'Folder %';

-- =====================================================================
-- Archivo y organización > Carpetas
-- =====================================================================
INSERT INTO productos (nombre, descripcion, atributos)
SELECT d.nombre, d.descripcion, d.atributos FROM (
  SELECT 'Carpeta plástica'             AS nombre, 'Carpeta plástica varios colores (carta y oficio).' AS descripcion, '{"material":"plastico","colores":"varios","tamanos":["carta","oficio"]}' AS atributos
  UNION ALL SELECT 'Carpeta fuelle plástica',  'Carpeta fuelle plástica tamaño oficio.',    '{"tipo":"fuelle","material":"plastico","tamano":"oficio"}'
  UNION ALL SELECT 'Carpeta broche',           'Carpeta de sobre con broche.',              '{"tipo":"sobre","cierre":"broche"}'
  UNION ALL SELECT 'Carpeta cordón',           'Carpeta de sobre con cordón.',              '{"tipo":"sobre","cierre":"cordon"}'
  UNION ALL SELECT 'Carpeta cierre hermético', 'Carpeta de sobre con cierre hermético.',    '{"tipo":"sobre","cierre":"hermetico"}'
  UNION ALL SELECT 'Carpeta bisel',            'Carpeta bisel (carta y oficio).',           '{"tipo":"bisel","tamanos":["carta","oficio"]}'
  UNION ALL SELECT 'Carpeta marrón',           'Carpeta marrón (carta y oficio).',          '{"color":"marron","tamanos":["carta","oficio"]}'
  UNION ALL SELECT 'Carpeta 4 aletas blanca',  'Carpeta 4 aletas color blanco.',            '{"tipo":"4_aletas","color":"blanca"}'
  UNION ALL SELECT 'Carpeta 4 aletas marrón',  'Carpeta 4 aletas color marrón.',            '{"tipo":"4_aletas","color":"marron"}'
  UNION ALL SELECT 'Carpeta blanca',           'Carpeta blanca (carta y oficio).',          '{"color":"blanca","tamanos":["carta","oficio"]}'
  UNION ALL SELECT 'Carpeta para archivador con gancho','Carpeta para archivador con gancho metálico.','{"tipo":"archivador","gancho":"metalico"}'
  UNION ALL SELECT 'Pastas para carpeta',      'Pastas para carpeta, varios colores.',      '{"tipo":"pastas"}'
) AS d WHERE NOT EXISTS (SELECT 1 FROM productos p WHERE p.nombre = d.nombre);

INSERT IGNORE INTO producto_categoria (producto_id, categoria_id)
SELECT p.id, c.id FROM productos p JOIN categorias c ON c.nombre = 'Carpetas'
WHERE p.nombre LIKE 'Carpeta %' OR p.nombre = 'Pastas para carpeta';

-- =====================================================================
-- Archivo y organización > Sobres
-- =====================================================================
INSERT INTO productos (nombre, descripcion, atributos)
SELECT d.nombre, d.descripcion, d.atributos FROM (
  SELECT 'Sobre manila'      AS nombre, 'Sobre manila (carta y oficio).' AS descripcion, '{"tipo":"manila","tamanos":["carta","oficio"]}' AS atributos
  UNION ALL SELECT 'Sobre blanco para cartas','Sobre blanco para cartas.',   '{"tipo":"carta","color":"blanco"}'
  UNION ALL SELECT 'Sobre para diezmo',       'Sobre para diezmo.',          '{"tipo":"diezmo"}'
) AS d WHERE NOT EXISTS (SELECT 1 FROM productos p WHERE p.nombre = d.nombre);

INSERT IGNORE INTO producto_categoria (producto_id, categoria_id)
SELECT p.id, c.id FROM productos p JOIN categorias c ON c.nombre = 'Sobres'
WHERE p.nombre LIKE 'Sobre %';

-- =====================================================================
-- Archivo y organización > Tablas y tableros
-- =====================================================================
INSERT INTO productos (nombre, descripcion, atributos)
SELECT d.nombre, d.descripcion, d.atributos FROM (
  SELECT 'Tabla planillera' AS nombre, 'Tabla planillera en plástico, madera o cartón.' AS descripcion, '{"tipo":"planillera","materiales":["plastico","madera","carton"]}' AS atributos
  UNION ALL SELECT 'Tablero metálico para escribir','Tablero metálico para escribir.',    '{"tipo":"tablero","material":"metal"}'
) AS d WHERE NOT EXISTS (SELECT 1 FROM productos p WHERE p.nombre = d.nombre);

INSERT IGNORE INTO producto_categoria (producto_id, categoria_id)
SELECT p.id, c.id FROM productos p JOIN categorias c ON c.nombre = 'Tablas y tableros'
WHERE p.nombre LIKE 'Tabla %' OR p.nombre LIKE 'Tablero %';

-- =====================================================================
-- Herramientas de escritorio > Grapadoras
-- =====================================================================
INSERT INTO productos (nombre, descripcion, atributos)
SELECT d.nombre, d.descripcion, d.atributos FROM (
  SELECT 'Grapadora estándar'  AS nombre, 'Grapadora de escritorio, capacidad 20 hojas.' AS descripcion, '{"tipo":"grapadora","capacidad":20}' AS atributos
  UNION ALL SELECT 'Grapadora varios tamaños','Grapadora en variados tamaños.',        '{"tipo":"grapadora","tamanos":"varios"}'
  UNION ALL SELECT 'Ganchos de grapadora',    'Ganchos (cargas) para grapadora.',       '{"tipo":"ganchos_grapadora"}'
) AS d WHERE NOT EXISTS (SELECT 1 FROM productos p WHERE p.nombre = d.nombre);

INSERT IGNORE INTO producto_categoria (producto_id, categoria_id)
SELECT p.id, c.id FROM productos p JOIN categorias c ON c.nombre = 'Grapadoras'
WHERE p.nombre LIKE 'Grapadora %' OR p.nombre = 'Ganchos de grapadora';

-- =====================================================================
-- Herramientas de escritorio > Perforadoras
-- =====================================================================
INSERT INTO productos (nombre, descripcion, atributos)
SELECT d.nombre, d.descripcion, d.atributos FROM (
  SELECT 'Perforadora sencilla' AS nombre, 'Perforadora de un hueco.' AS descripcion, '{"tipo":"sencilla","huecos":1}' AS atributos
  UNION ALL SELECT 'Perforadora doble',    'Perforadora doble (dos huecos).','{"tipo":"doble","huecos":2}'
) AS d WHERE NOT EXISTS (SELECT 1 FROM productos p WHERE p.nombre = d.nombre);

INSERT IGNORE INTO producto_categoria (producto_id, categoria_id)
SELECT p.id, c.id FROM productos p JOIN categorias c ON c.nombre = 'Perforadoras'
WHERE p.nombre LIKE 'Perforadora %';

-- =====================================================================
-- Herramientas de escritorio > Tijeras y bisturíes
-- =====================================================================
INSERT INTO productos (nombre, descripcion, atributos)
SELECT d.nombre, d.descripcion, d.atributos FROM (
  SELECT 'Bisturí grande'      AS nombre, 'Bisturí grande.' AS descripcion, '{"tipo":"bisturi","tamano":"grande"}' AS atributos
  UNION ALL SELECT 'Bisturí pequeño',    'Bisturí pequeño.',                '{"tipo":"bisturi","tamano":"pequeno"}'
  UNION ALL SELECT 'Bisturí industrial', 'Bisturí industrial.',             '{"tipo":"bisturi","tamano":"industrial"}'
  UNION ALL SELECT 'Bisturí quirúrgico', 'Bisturí quirúrgico.',              '{"tipo":"bisturi","uso":"quirurgico"}'
  UNION ALL SELECT 'Tijeras punta roma', 'Tijeras punta roma.',              '{"tipo":"tijera","punta":"roma"}'
  UNION ALL SELECT 'Tijeras para pelo',  'Tijeras para cortar cabello.',    '{"tipo":"tijera","uso":"pelo"}'
  UNION ALL SELECT 'Tijeras para enfermera','Tijeras tipo enfermera.',       '{"tipo":"tijera","uso":"enfermera"}'
) AS d WHERE NOT EXISTS (SELECT 1 FROM productos p WHERE p.nombre = d.nombre);

INSERT IGNORE INTO producto_categoria (producto_id, categoria_id)
SELECT p.id, c.id FROM productos p JOIN categorias c ON c.nombre = 'Tijeras y bisturíes'
WHERE p.nombre LIKE 'Bisturí %' OR p.nombre LIKE 'Tijeras %';

-- =====================================================================
-- Herramientas de escritorio > Lupas y punzones
-- =====================================================================
INSERT INTO productos (nombre, descripcion, atributos)
SELECT d.nombre, d.descripcion, d.atributos FROM (
  SELECT 'Lupa grande'    AS nombre, 'Lupa tamaño grande.' AS descripcion, '{"tipo":"lupa","tamano":"grande"}' AS atributos
  UNION ALL SELECT 'Lupa mediana',       'Lupa tamaño mediano.',             '{"tipo":"lupa","tamano":"mediano"}'
  UNION ALL SELECT 'Lupa pequeña',       'Lupa tamaño pequeño.',             '{"tipo":"lupa","tamano":"pequeno"}'
  UNION ALL SELECT 'Punzón metálico',    'Punzón metálico.',                 '{"tipo":"punzon","material":"metal"}'
) AS d WHERE NOT EXISTS (SELECT 1 FROM productos p WHERE p.nombre = d.nombre);

INSERT IGNORE INTO producto_categoria (producto_id, categoria_id)
SELECT p.id, c.id FROM productos p JOIN categorias c ON c.nombre = 'Lupas y punzones'
WHERE p.nombre LIKE 'Lupa %' OR p.nombre = 'Punzón metálico';

-- =====================================================================
-- Herramientas de escritorio > Otros
-- =====================================================================
INSERT INTO productos (nombre, descripcion, atributos)
SELECT d.nombre, d.descripcion, d.atributos FROM (
  SELECT 'Cuenta fácil'   AS nombre, 'Cuenta fácil (ábaco didáctico).' AS descripcion, '{"tipo":"cuenta_facil"}' AS atributos
  UNION ALL SELECT 'Huellero',           'Huellero para trámites.',                 '{"tipo":"huellero"}'
  UNION ALL SELECT 'Afilaminas',         'Afilaminas para dibujo técnico.',         '{"tipo":"afilaminas"}'
  UNION ALL SELECT 'Billetes didácticos', 'Billetes didácticos para juegos.',        '{"tipo":"billetes_didacticos"}'
) AS d WHERE NOT EXISTS (SELECT 1 FROM productos p WHERE p.nombre = d.nombre);

INSERT IGNORE INTO producto_categoria (producto_id, categoria_id)
SELECT p.id, c.id FROM productos p JOIN categorias c ON c.nombre = 'Otros'
WHERE p.nombre IN ('Cuenta fácil','Huellero','Afilaminas','Billetes didácticos');