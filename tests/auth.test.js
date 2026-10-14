const test = require("node:test");
const assert = require("node:assert/strict");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const pool = require("../src/config/db");
const { login } = require("../src/controllers/auth.controller");
const { requireAuth } = require("../src/middleware/auth.middleware");

process.env.JWT_SECRET = process.env.JWT_SECRET || "test_secret";

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

test("login responde 400 cuando faltan email o password", async () => {
  const res = buildRes();

  await login({ body: {} }, res, () => {});

  assert.equal(res.statusCode, 400);
  assert.deepEqual(res.payload, { error: "Email y contraseña son obligatorios." });
});

test("login genera un token cuando las credenciales son válidas", async () => {
  const res = buildRes();
  const admin = {
    id: 7,
    nombre: "Admin Test",
    email: "admin@test.com",
    password_hash: "hash_valido",
  };

  const queryMock = require("node:test").mock.method(pool, "query", async () => [[admin]]);
  const compareMock = require("node:test").mock.method(bcrypt, "compare", async () => true);
  const signMock = require("node:test").mock.method(jwt, "sign", () => "token_test");

  await login(
    { body: { email: "admin@test.com", password: "secret123" } },
    res,
    () => {}
  );

  assert.equal(res.payload.token, "token_test");
  assert.deepEqual(res.payload.admin, {
    id: 7,
    nombre: "Admin Test",
    email: "admin@test.com",
  });
  assert.equal(queryMock.mock.calls.length, 1);
  assert.equal(compareMock.mock.calls.length, 1);
  assert.equal(signMock.mock.calls.length, 1);
});

test("login responde 401 cuando el usuario no existe", async () => {
  const res = buildRes();

  require("node:test").mock.method(pool, "query", async () => [[]]);

  await login({ body: { email: "noexiste@test.com", password: "secret123" } }, res, () => {});

  assert.equal(res.statusCode, 401);
  assert.deepEqual(res.payload, { error: "Credenciales inválidas." });
});

test("requireAuth rechaza peticiones sin token", () => {
  const res = buildRes();
  let calledNext = false;
  const req = { headers: {} };

  requireAuth(req, res, () => {
    calledNext = true;
  });

  assert.equal(res.statusCode, 401);
  assert.deepEqual(res.payload, { error: "No autorizado. Debe iniciar sesión." });
  assert.equal(calledNext, false);
});

test("requireAuth acepta un token Bearer válido y agrega el admin", () => {
  const res = buildRes();
  let calledNext = false;
  const token = jwt.sign({ id: 99, email: "admin@test.com" }, process.env.JWT_SECRET, { expiresIn: "1h" });
  const req = { headers: { authorization: `Bearer ${token}` } };

  requireAuth(req, res, () => {
    calledNext = true;
  });

  assert.equal(calledNext, true);
  assert.deepEqual(req.admin, { id: 99, email: "admin@test.com" });
});

test("requireAuth rechaza un token inválido", () => {
  const res = buildRes();
  let calledNext = false;
  const req = { headers: { authorization: "Bearer token_invalido" } };

  requireAuth(req, res, () => {
    calledNext = true;
  });

  assert.equal(res.statusCode, 401);
  assert.deepEqual(res.payload, { error: "Sesión inválida o expirada." });
  assert.equal(calledNext, false);
});
