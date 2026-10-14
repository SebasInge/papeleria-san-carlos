-- =====================================================================
-- Papelería San Carlos — Catálogo Digital
-- Esquema de base de datos (MariaDB)
-- Jerarquía de categorías (árbol de N niveles) + productos multi-categoría
-- =====================================================================

CREATE DATABASE IF NOT EXISTS papeleria_san_carlos
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE papeleria_san_carlos;

-- ---------------------------------------------------------------------
-- Administradores (RF-02: tipos de usuario / autenticación)
-- No existe tabla de "clientes": el catálogo es de acceso público,
-- solo el administrador requiere cuenta.
-- ---------------------------------------------------------------------
CREATE TABLE administradores (
  id            INT AUTO_INCREMENT PRIMARY KEY,
  nombre        VARCHAR(100)  NOT NULL,
  email         VARCHAR(150)  NOT NULL UNIQUE,
  password_hash VARCHAR(255)  NOT NULL,
  created_at    TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- Categorías (árbol jerárquico de N niveles) — RF-07, RF-08, RF-11, RF-13
--  - tipo: 'normal' | 'temporada'  -> solo significativo en la raíz.
--  - padre_id: NULL = categoría raíz (nivel 1). Autorreferencia.
--  - icono: sugerencia de icono para el frontend; opcional en cualquier
--           nivel, aunque en la práctica solo se usa en las raíces.
--  - orden: posición entre hermanas dentro del mismo padre.
--  - activa: activación manual (p. ej. temporadas); aplica en cualquier nivel.
-- No se borran categorías con hijos o productos: ON DELETE RESTRICT.
--
-- Nota: la restricción UNIQUE (padre_id, nombre) de abajo NO evita nombres
-- duplicados entre categorías raíz, porque en MariaDB/InnoDB dos valores
-- NULL nunca se consideran iguales para una clave única (todas las raíces
-- tienen padre_id = NULL). Para las raíces, la unicidad de nombre se
-- valida en el controlador (categorias.controller.js), no en la base de datos.
-- ---------------------------------------------------------------------
CREATE TABLE categorias (
  id        INT AUTO_INCREMENT PRIMARY KEY,
  nombre    VARCHAR(100) NOT NULL,
  padre_id  INT NULL,
  tipo      ENUM('normal','temporada') NOT NULL DEFAULT 'normal',
  icono     VARCHAR(100) NULL,
  orden     INT NOT NULL DEFAULT 0,
  activa    BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
             ON UPDATE CURRENT_TIMESTAMP,

  CONSTRAINT uq_categorias_padre_nombre UNIQUE (padre_id, nombre),
  CONSTRAINT fk_categorias_padre
    FOREIGN KEY (padre_id) REFERENCES categorias(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE INDEX idx_categorias_padre       ON categorias(padre_id);
CREATE INDEX idx_categorias_padre_orden ON categorias(padre_id, orden);
CREATE INDEX idx_categorias_tipo_activa ON categorias(tipo, activa);

-- ---------------------------------------------------------------------
-- Productos (RF-01: catálogo; RF-03/RF-04: sin precio ni stock de forma
-- deliberada — esos campos no existen en esta tabla)
--
-- atributos: JSON libre para describir características específicas del
-- producto, que varían según su tipo. Ejemplos:
--   {"marca":"Bic","color":"azul","punta":"0.7mm"}
--   {"tipo":"bristol","color":"verde","tamano":"pliego"}
--   {"tipo":"cosido","hojas":100,"rayado":"cuadriculado"}
-- El contenido NO se valida a nivel de BD (JSON solo verifica que sea
-- JSON válido). Las claves y valores se acuerdan en la aplicación.
-- ---------------------------------------------------------------------
CREATE TABLE productos (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  nombre      VARCHAR(150) NOT NULL,
  descripcion TEXT NULL,
  imagen_url  VARCHAR(255) NULL,
  atributos   JSON NULL
              COMMENT 'Atributos flexibles del producto. Ej: {"marca":"Bic","color":"azul"}',
  creado_por  INT NULL,
  created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
              ON UPDATE CURRENT_TIMESTAMP,

  CONSTRAINT fk_productos_admin
    FOREIGN KEY (creado_por) REFERENCES administradores(id)
    ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE INDEX idx_productos_nombre ON productos(nombre);

-- ---------------------------------------------------------------------
-- Relación producto-categoría (muchos a muchos)
-- Un producto puede estar asociado a categorías de cualquier nivel del
-- árbol, y de varias ramas a la vez. La visibilidad "hacia arriba"
-- (herencia: un producto de una subcategoría también aparece al navegar
-- su categoría padre) se resuelve en la consulta (productos.controller.js),
-- no en esta tabla.
-- ---------------------------------------------------------------------
CREATE TABLE producto_categoria (
  producto_id  INT NOT NULL,
  categoria_id INT NOT NULL,
  PRIMARY KEY (producto_id, categoria_id),

  CONSTRAINT fk_pc_producto
    FOREIGN KEY (producto_id) REFERENCES productos(id)
    ON DELETE CASCADE,
  CONSTRAINT fk_pc_categoria
    FOREIGN KEY (categoria_id) REFERENCES categorias(id)
    ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE INDEX idx_pc_categoria ON producto_categoria(categoria_id);

-- ---------------------------------------------------------------------
-- Banners (RF-05: anuncios destacados; RF-06: edición por admin)
-- ---------------------------------------------------------------------
CREATE TABLE banners (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  imagen_url  VARCHAR(255) NOT NULL,
  orden       INT NOT NULL DEFAULT 0,
  activo      BOOLEAN NOT NULL DEFAULT TRUE,
  creado_por  INT NULL,
  created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

  CONSTRAINT fk_banners_admin
    FOREIGN KEY (creado_por) REFERENCES administradores(id)
    ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE INDEX idx_banners_activo_orden ON banners(activo, orden);