// Envuelve un controlador async para que cualquier error (ej. una consulta SQL
// fallida) llegue al manejador de errores centralizado en vez de dejar la
// petición sin respuesta.
function asyncHandler(fn) {
  return (req, res, next) => Promise.resolve(fn(req, res, next)).catch(next);
}

module.exports = { asyncHandler };
