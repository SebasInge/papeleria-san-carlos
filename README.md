# Backend — Catálogo Digital Papelería San Carlos

## Estado del proyecto (Sprint 2 — Semanas 9-10)
- [x] Semana 4: Configuración inicial + modelo de datos + módulo de autenticación
- [x] Semana 5-7: Módulo de catálogo (productos, categorías, activación de temporada) y administración
- [x] Sprint 2 (Semanas 9-10): banner de anuncios (RF-05/RF-06) activo; categorías de temporada (RF-08) e íconos de categoría (RF-13) verificados
- [ ] Sprint 3 (Semanas 12-13): buscador (RF-10), detalle de producto con WhatsApp (RF-09/RF-12), integración final de frontend

> Nota: el submenú de navegación (RF-11) y la barra lateral de categorías
> (RF-13) no requieren endpoints adicionales: se resuelven en el frontend
> combinando `GET /api/categorias` (nombre + ícono) con
> `GET /api/productos?categoria=ID`.
> El buscador (RF-10) y el detalle de producto (RF-12) pertenecen al Sprint 3
> y aún no se implementan, para que el producto no vaya adelantado a la
> planificación.

## Arquitectura

Arquitectura en capas, estilo MVC simplificado (sin vistas, ya que el frontend
es independiente):

```
Cliente / Panel admin (frontend)
          │  HTTP (JSON)
          ▼
     routes/*.routes.js      → define las URLs y qué controlador atiende cada una
          │
          ▼
  middleware/auth.middleware → valida el JWT en las rutas de administración (RF-02)
          │
          ▼
 controllers/*.controller.js → lógica de negocio de cada módulo
          │
          ▼
     config/db.js (pool)     → acceso a MariaDB (mysql2)
          │
          ▼
        MariaDB              → esquema definido en schema.sql
```

## Estructura de carpetas

```
backend/
├── server.js                    # Punto de entrada
├── package.json
├── .env.example                 # Copiar a .env y completar
├── schema.sql                   # Modelo de datos MariaDB (diseño completo)
├── seed_data.sql                # Datos de prueba (categorías y productos)
├── scripts/
│   └── seedAdmin.js              # Crea el primer administrador
└── src/
    ├── app.js                   # Configuración de Express y montaje de rutas
    ├── config/
    │   └── db.js                 # Pool de conexión a MariaDB
    ├── middleware/
    │   ├── auth.middleware.js    # Verificación de JWT (RF-02)
    │   └── asyncHandler.js       # Captura de errores en controladores async
    ├── controllers/
    │   ├── auth.controller.js
    │   ├── productos.controller.js
    │   └── categorias.controller.js
    └── routes/
        ├── auth.routes.js
        ├── productos.routes.js
        ├── categorias.routes.js
        └── banners.routes.js
```

## Endpoints disponibles en esta versión

| Método | Ruta                          | Acceso   | RF relacionado |
|--------|-------------------------------|----------|-----------------|
| POST   | /api/auth/login               | Público  | RF-02           |
| GET    | /api/productos                | Público  | RF-01, RF-07    |
| POST   | /api/productos                | Admin    | RF-14           |
| PUT    | /api/productos/:id            | Admin    | RF-14           |
| DELETE | /api/productos/:id            | Admin    | RF-14           |
| GET    | /api/categorias               | Público  | RF-07, RF-08    |
| GET    | /api/categorias/todas         | Admin    | RF-14           |
| POST   | /api/categorias                | Admin    | RF-14           |
| PATCH  | /api/categorias/:id/estado    | Admin    | RF-08 (activar/desactivar temporada) |
| DELETE | /api/categorias/:id           | Admin    | RF-14           |
| GET    | /api/banners                  | Público  | RF-05           |
| POST   | /api/banners                  | Admin    | RF-06           |
| PUT    | /api/banners/:id              | Admin    | RF-06 (reordenar/desactivar) |
| DELETE | /api/banners/:id              | Admin    | RF-06           |

Nota: ningún endpoint expone ni acepta campos de precio o stock (RF-03, RF-04).

## Integración continua (CI)

Cada `push` a `main` dispara un workflow de GitHub Actions (`.github/workflows/ci.yml`) que:
1. Instala las dependencias del proyecto.
2. Verifica la sintaxis de todos los archivos JavaScript.
3. Levanta una base de datos MariaDB temporal y carga `schema.sql`.
4. Arranca el servidor y valida que `GET /api/health` responda correctamente.

El resultado se ve en la pestaña **Actions** del repositorio.

## Casos de prueba

De los 20 casos de prueba documentados en `Casos_de_Prueba.docx`, en esta
versión aplican los relacionados con autenticación, catálogo, categorías
de temporada, administración de productos y banner de anuncios
(CP-01 a CP-06, CP-12 a CP-18, CP-20). Los relacionados con buscador y
detalle de producto (CP-07, CP-08, CP-10, CP-11) y la usabilidad móvil
(CP-19) dependen del frontend y se evaluarán en el Sprint 3.

Las pruebas unitarias del backend se ejecutan con `npm test`
(`tests/auth.test.js`, `tests/banners.test.js`).

## Frontend (Sprint 2)

La carpeta `frontend/` contiene el catálogo público: página estática
(HTML + CSS + JavaScript sin dependencias) que consume la API.

| Archivo | Contenido |
|---------|-----------|
| `index.html` | Estructura: cabecera, barra lateral de categorías, banner y rejilla de productos |
| `styles.css` | Paleta institucional (RNF-01) y diseño responsive (RNF-02) |
| `app.js` | Consumo de `/api/categorias`, `/api/productos` y `/api/banners` |

Requerimientos cubiertos: RF-01, RF-05, RF-07, RF-08, RF-11 y RF-13.
El buscador (RF-10), el detalle de producto (RF-12) y el botón de WhatsApp
(RF-09) no se incluyen: pertenecen al Sprint 3.

Para verlo: con el backend corriendo (`npm start`), abrir
`frontend/index.html` en el navegador. Si el backend no está en
`http://localhost:3000`, ajustar la constante `API` al inicio de `app.js`.

## Puesta en marcha

1. Ejecutar `schema.sql` en MariaDB (crea la base de datos y las tablas).
2. `cp .env.example .env` y completar las credenciales de la base de datos y un `JWT_SECRET`.
3. `npm install`
4. Crear el primer administrador: `node scripts/seedAdmin.js "Nombre" correo@ejemplo.com "contraseña"`
5. (Opcional) Cargar datos de prueba: ejecutar `seed_data.sql`.
6. `npm run dev` (o `npm start`)
7. Verificar `GET http://localhost:3000/api/health` → `{ "ok": true }`
