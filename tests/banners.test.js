const test = require("node:test");
const assert = require("node:assert/strict");
const pool = require("../src/config/db");
const banners = require("../src/controllers/banners.controller");

test.afterEach(() => {
  require("node:test").mock.restoreAll();
});

function buildRes() {
  return {
    statusCode: null,
    payload: null,
    status(code) {
      this.statusCode = code;
      return this;
    },
    json(data) {
      this.payload = data;
      return this;
    },
  };
}

// --- RF-05: banner público (CP-16) ---

test("listarActivos devuelve solo banners activos y ordenados", async () => {
  const res = buildRes();
  const filas = [
    { id: 2, imagen_url: "promo2.jpg", orden: 1 },
    { id: 5, imagen_url: "promo5.jpg", orden: 2 },
  ];

  const queryMock = require("node:test").mock.method(pool, "query", async () => [filas]);

  await banners.listarActivos({}, res, () => {});

  assert.deepEqual(res.payload, filas);
  const sql = queryMock.mock.calls[0].arguments[0];
  assert.match(sql, /activo = TRUE/);
  assert.match(sql, /ORDER BY orden/);
});

test("listarActivos nunca expone precio ni stock (RF-03, RF-04)", async () => {
  const res = buildRes();
  const queryMock = require("node:test").mock.method(pool, "query", async () => [[]]);

  await banners.listarActivos({}, res, () => {});

  const sql = queryMock.mock.calls[0].arguments[0];
  assert.doesNotMatch(sql, /precio/i);
  assert.doesNotMatch(sql, /stock/i);
});

// --- RF-06: administración del banner (CP-17) ---

test("crear rechaza un banner sin imagen", async () => {
  const res = buildRes();

  await banners.crear({ body: {}, admin: { id: 1 } }, res, () => {});

  assert.equal(res.statusCode, 400);
  assert.deepEqual(res.payload, { error: "La imagen del banner es obligatoria." });
});

test("crear registra la imagen junto al administrador que la agregó", async () => {
  const res = buildRes();
  const queryMock = require("node:test").mock.method(pool, "query", async () => [{ insertId: 11 }]);

  await banners.crear(
    { body: { imagen_url: "navidad.jpg", orden: 3 }, admin: { id: 7 } },
    res,
    () => {}
  );

  assert.equal(res.statusCode, 201);
  assert.deepEqual(res.payload, { id: 11, imagen_url: "navidad.jpg", orden: 3 });
  assert.deepEqual(queryMock.mock.calls[0].arguments[1], ["navidad.jpg", 3, 7]);
});

test("crear usa orden 0 por defecto cuando no se envía", async () => {
  const res = buildRes();
  const queryMock = require("node:test").mock.method(pool, "query", async () => [{ insertId: 12 }]);

  await banners.crear({ body: { imagen_url: "regreso.jpg" }, admin: { id: 7 } }, res, () => {});

  assert.equal(queryMock.mock.calls[0].arguments[1][1], 0);
});

test("actualizar desactiva un banner sin exigir imagen_url ni orden", async () => {
  const res = buildRes();
  const queryMock = require("node:test").mock.method(pool, "query", async () => [{}]);

  await banners.actualizar({ params: { id: "5" }, body: { activo: false } }, res, () => {});

  assert.deepEqual(res.payload, { ok: true });
  // Los campos no enviados viajan como NULL para que COALESCE conserve su valor actual.
  assert.deepEqual(queryMock.mock.calls[0].arguments[1], [null, null, false, "5"]);
  assert.match(queryMock.mock.calls[0].arguments[0], /COALESCE/);
});

test("actualizar reordena sin tocar la imagen existente", async () => {
  const res = buildRes();
  const queryMock = require("node:test").mock.method(pool, "query", async () => [{}]);

  await banners.actualizar({ params: { id: "5" }, body: { orden: 1 } }, res, () => {});

  assert.deepEqual(queryMock.mock.calls[0].arguments[1], [null, 1, null, "5"]);
});

test("actualizar aplica los tres campos cuando se envían todos", async () => {
  const res = buildRes();
  const queryMock = require("node:test").mock.method(pool, "query", async () => [{}]);

  await banners.actualizar(
    { params: { id: "5" }, body: { imagen_url: "nueva.jpg", orden: 2, activo: true } },
    res,
    () => {}
  );

  assert.deepEqual(queryMock.mock.calls[0].arguments[1], ["nueva.jpg", 2, true, "5"]);
});

test("eliminar borra el banner indicado", async () => {
  const res = buildRes();
  const queryMock = require("node:test").mock.method(pool, "query", async () => [{}]);

  await banners.eliminar({ params: { id: "9" } }, res, () => {});

  assert.deepEqual(res.payload, { ok: true });
  assert.deepEqual(queryMock.mock.calls[0].arguments[1], ["9"]);
});
