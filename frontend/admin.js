/* =====================================================================
   Panel de administración — Papelería San Carlos
   Funcionalidad:
     - Login con JWT
     - CRUD de productos (crear, editar, eliminar, subir imagen)
     - CRUD de categorías (crear, editar, eliminar)
     - Pestañas: Productos | Categorías
   ===================================================================== */

const API = "/api";

const el = {
  // Vistas
  vistaLogin: document.getElementById("vistaLogin"),
  vistaPanel: document.getElementById("vistaPanel"),
  // Login
  formLogin: document.getElementById("formLogin"),
  campoEmail: document.getElementById("campoEmail"),
  campoPassword: document.getElementById("campoPassword"),
  loginError: document.getElementById("loginError"),
  botonLogin: document.getElementById("botonLogin"),
  // Panel
  botonSalir: document.getElementById("botonSalir"),
  // Productos
  botonNuevoProducto: document.getElementById("botonNuevoProducto"),
  estadoProductos: document.getElementById("estadoProductos"),
  tablaProductos: document.getElementById("tablaProductos"),
  cuerpoProductos: document.getElementById("cuerpoProductos"),
  // Categorías
  botonNuevaCategoria: document.getElementById("botonNuevaCategoria"),
  estadoCategorias: document.getElementById("estadoCategorias"),
  listaAdminCategorias: document.getElementById("listaAdminCategorias"),
  // Modal producto
  modalProducto: document.getElementById("modalProducto"),
  modalFondo: document.getElementById("modalFondo"),
  modalTitulo: document.getElementById("modalTitulo"),
  formProducto: document.getElementById("formProducto"),
  productoId: document.getElementById("productoId"),
  productoNombre: document.getElementById("productoNombre"),
  productoDescripcion: document.getElementById("productoDescripcion"),
  productoImagen: document.getElementById("productoImagen"),
  productoAtributos: document.getElementById("productoAtributos"),
  categoriasProducto: document.getElementById("categoriasProducto"),
  productoError: document.getElementById("productoError"),
  botonCancelar: document.getElementById("botonCancelar"),
  botonGuardar: document.getElementById("botonGuardar"),
  // Upload
  botonSubir: document.getElementById("botonSubir"),
  nombreArchivo: document.getElementById("nombreArchivo"),
  previewImagen: document.getElementById("previewImagen"),
  zonaUpload: document.getElementById("zonaUpload"),
  // Modal categoría
  modalCategoria: document.getElementById("modalCategoria"),
  modalCategoriaFondo: document.getElementById("modalCategoriaFondo"),
  modalCategoriaTitulo: document.getElementById("modalCategoriaTitulo"),
  formCategoria: document.getElementById("formCategoria"),
  categoriaId: document.getElementById("categoriaId"),
  categoriaNombre: document.getElementById("categoriaNombre"),
  categoriaPadre: document.getElementById("categoriaPadre"),
  categoriaTipo: document.getElementById("categoriaTipo"),
  categoriaIcono: document.getElementById("categoriaIcono"),
  categoriaOrden: document.getElementById("categoriaOrden"),
  categoriaError: document.getElementById("categoriaError"),
  botonCancelarCategoria: document.getElementById("botonCancelarCategoria"),
  botonGuardarCategoria: document.getElementById("botonGuardarCategoria"),
};

// -------- Estado en memoria --------
let token = localStorage.getItem("admin_token") || null;
let categoriasCache = [];
let categoriasPlanas = [];
let productosCache = [];

// -------- Utilidades HTTP --------

async function api(ruta, opciones = {}) {
  const headers = { "Content-Type": "application/json", ...(opciones.headers || {}) };
  if (token) headers.Authorization = `Bearer ${token}`;

  const resp = await fetch(`${API}${ruta}`, { ...opciones, headers });

  if (resp.status === 401 && ruta !== "/auth/login") {
    cerrarSesion();
    throw new Error("Sesión expirada. Inicia sesión de nuevo.");
  }

  const texto = await resp.text();
  const datos = texto ? JSON.parse(texto) : null;

  if (!resp.ok) {
    throw new Error(datos?.error || `Error ${resp.status}`);
  }
  return datos;
}

// -------- Autenticación --------

el.formLogin.addEventListener("submit", async (e) => {
  e.preventDefault();
  el.loginError.hidden = true;
  el.botonLogin.disabled = true;
  el.botonLogin.textContent = "Ingresando…";

  try {
    const datos = await api("/auth/login", {
      method: "POST",
      body: JSON.stringify({
        email: el.campoEmail.value.trim(),
        password: el.campoPassword.value,
      }),
    });
    token = datos.token;
    localStorage.setItem("admin_token", token);
    el.formLogin.reset();
    await entrarAlPanel();
  } catch (err) {
    el.loginError.textContent = err.message;
    el.loginError.hidden = false;
  } finally {
    el.botonLogin.disabled = false;
    el.botonLogin.textContent = "Ingresar";
  }
});

el.botonSalir.addEventListener("click", cerrarSesion);

function cerrarSesion() {
  token = null;
  localStorage.removeItem("admin_token");
  el.vistaPanel.hidden = true;
  el.vistaLogin.hidden = false;
}

// -------- Carga inicial --------

async function entrarAlPanel() {
  el.vistaLogin.hidden = true;
  el.vistaPanel.hidden = false;
  await cargarCategorias();
  await cargarProductos();
}

async function init() {
  if (!token) {
    el.vistaLogin.hidden = false;
    return;
  }
  try {
    await api("/categorias/todas");
    await entrarAlPanel();
  } catch {
    cerrarSesion();
  }
}

/* =====================================================
   CATEGORÍAS
   ===================================================== */

async function cargarCategorias() {
  el.estadoCategorias.textContent = "Cargando…";
  el.estadoCategorias.hidden = false;
  el.listaAdminCategorias.hidden = true;

  try {
    const todas = await api("/categorias/todas");
    categoriasCache = armarArbol(todas);
    categoriasPlanas = aplanarConNivel(categoriasCache);
    renderizarCategorias(categoriasCache);
    renderizarCheckboxesCategorias();
    el.estadoCategorias.hidden = true;
    el.listaAdminCategorias.hidden = false;
  } catch (err) {
    el.estadoCategorias.textContent = "Error: " + err.message;
    el.estadoCategorias.classList.add("admin-estado--error");
  }
}

function armarArbol(categorias) {
  const porId = new Map(categorias.map((c) => [c.id, { ...c, hijos: [] }]));
  const raices = [];
  for (const cat of porId.values()) {
    if (cat.padre_id === null) raices.push(cat);
    else {
      const padre = porId.get(cat.padre_id);
      if (padre) padre.hijos.push(cat);
    }
  }
  const ordenar = (lista) => {
    lista.sort((a, b) => (a.orden - b.orden) || a.nombre.localeCompare(b.nombre));
    lista.forEach((c) => ordenar(c.hijos));
  };
  ordenar(raices);
  return raices;
}

function aplanarConNivel(arbol, nivel = 1, salida = []) {
  for (const cat of arbol) {
    salida.push({ ...cat, nivel });
    if (cat.hijos && cat.hijos.length) aplanarConNivel(cat.hijos, nivel + 1, salida);
  }
  return salida;
}

function renderizarCategorias(arbol) {
  el.listaAdminCategorias.innerHTML = "";
  const planas = aplanarConNivel(arbol);
  planas.forEach((cat) => {
    const li = document.createElement("li");
    li.className = `admin-categorias__nodo admin-categorias__nivel-${Math.min(cat.nivel, 4)}`;
    if (cat.tipo === "temporada" && cat.activa === false) {
      li.classList.add("admin-categorias__inactiva");
    }

    // Nombre
    const texto = document.createElement("span");
    texto.className = "admin-categorias__texto";
    texto.textContent = cat.nombre;
    li.append(texto);

    // Badge de temporada
    if (cat.tipo === "temporada") {
      const badge = document.createElement("span");
      badge.className = "admin-categorias__temporada";
      badge.textContent = cat.activa ? "Activa" : "Inactiva";
      li.append(badge);
    }

    // Botones de acción
    const acciones = document.createElement("span");
    acciones.className = "admin-categorias__acciones";

    const btnEditar = document.createElement("button");
    btnEditar.type = "button";
    btnEditar.className = "admin-boton admin-boton--mini";
    btnEditar.textContent = "Editar";
    btnEditar.addEventListener("click", () => abrirModalEditarCategoria(cat));
    acciones.append(btnEditar);

    const btnEliminar = document.createElement("button");
    btnEliminar.type = "button";
    btnEliminar.className = "admin-boton admin-boton--mini admin-boton--peligro";
    btnEliminar.textContent = "Eliminar";
    btnEliminar.style.marginLeft = "0.3rem";
    btnEliminar.addEventListener("click", () => eliminarCategoria(cat));
    acciones.append(btnEliminar);

    li.append(acciones);
    el.listaAdminCategorias.append(li);
  });
}

function renderizarCheckboxesCategorias(seleccionadas = []) {
  const set = new Set(seleccionadas.map(String));
  el.categoriasProducto.innerHTML = "";
  categoriasPlanas.forEach((cat) => {
    if (cat.tipo === "temporada" && !cat.activa) return;

    const label = document.createElement("label");
    const checkbox = document.createElement("input");
    checkbox.type = "checkbox";
    checkbox.value = cat.id;
    checkbox.checked = set.has(String(cat.id));

    const texto = document.createElement("span");
    texto.textContent = " ".repeat((cat.nivel - 1) * 2) + cat.nombre;

    label.append(checkbox, texto);
    el.categoriasProducto.append(label);
  });
}

// -------- Modal categoría --------

el.botonNuevaCategoria.addEventListener("click", abrirModalNuevaCategoria);

function abrirModalNuevaCategoria() {
  el.modalCategoriaTitulo.textContent = "Nueva categoría";
  el.formCategoria.reset();
  el.categoriaId.value = "";
  el.categoriaOrden.value = "0";
  el.categoriaTipo.value = "normal";
  el.categoriaError.hidden = true;
  renderizarSelectPadres(null);
  el.modalCategoria.hidden = false;
  el.categoriaNombre.focus();
}

function abrirModalEditarCategoria(cat) {
  el.modalCategoriaTitulo.textContent = "Editar categoría";
  el.categoriaId.value = cat.id;
  el.categoriaNombre.value = cat.nombre || "";
  el.categoriaTipo.value = cat.tipo || "normal";
  el.categoriaIcono.value = cat.icono || "";
  el.categoriaOrden.value = cat.orden || 0;
  el.categoriaError.hidden = true;
  renderizarSelectPadres(cat.id);
  el.categoriaPadre.value = cat.padre_id ? String(cat.padre_id) : "";
  el.modalCategoria.hidden = false;
  el.categoriaNombre.focus();
}

function cerrarModalCategoria() {
  el.modalCategoria.hidden = true;
}

el.botonCancelarCategoria.addEventListener("click", cerrarModalCategoria);
el.modalCategoriaFondo.addEventListener("click", cerrarModalCategoria);
document.addEventListener("keydown", (e) => {
  if (e.key === "Escape" && !el.modalCategoria.hidden) cerrarModalCategoria();
});

// Rellena el select de categorías padre, excluyendo la categoría en edición
// y todos sus descendientes (para evitar ciclos en el árbol).
function renderizarSelectPadres(excluirId) {
  const excluidos = excluirId ? obtenerDescendientes(excluirId) : new Set();
  el.categoriaPadre.innerHTML = '<option value="">— Ninguna (categoría raíz) —</option>';

  const planas = aplanarConNivel(categoriasCache);
  planas.forEach((cat) => {
    if (excluidos.has(cat.id)) return;
    const option = document.createElement("option");
    option.value = cat.id;
    option.textContent = "  ".repeat((cat.nivel - 1) * 2) + cat.nombre;
    el.categoriaPadre.append(option);
  });
}

// Devuelve un Set con el id de la categoría y todos sus descendientes.
function obtenerDescendientes(catId, arbol = categoriasCache, salida = new Set()) {
  const marcarDescendientes = (nodo) => {
    salida.add(nodo.id);
    if (nodo.hijos) nodo.hijos.forEach(marcarDescendientes);
  };
  const buscar = (nodo) => {
    if (nodo.id === catId) {
      marcarDescendientes(nodo);
      return true;
    }
    if (nodo.hijos) {
      for (const hijo of nodo.hijos) {
        if (buscar(hijo)) return true;
      }
    }
    return false;
  };
  for (const raiz of arbol) {
    if (buscar(raiz)) break;
  }
  return salida;
}

// Guardar categoría (crear o editar)
el.formCategoria.addEventListener("submit", async (e) => {
  e.preventDefault();
  el.categoriaError.hidden = true;
  el.botonGuardarCategoria.disabled = true;
  el.botonGuardarCategoria.textContent = "Guardando…";

  try {
    const id = el.categoriaId.value;
    const cuerpo = {
      nombre: el.categoriaNombre.value.trim(),
      tipo: el.categoriaTipo.value,
      icono: el.categoriaIcono.value.trim() || null,
      orden: parseInt(el.categoriaOrden.value, 10) || 0,
      padre_id: el.categoriaPadre.value ? parseInt(el.categoriaPadre.value, 10) : null,
    };

    if (!cuerpo.nombre) throw new Error("El nombre es obligatorio.");

    if (id) {
      await api(`/categorias/${id}`, {
        method: "PUT",
        body: JSON.stringify(cuerpo),
      });
    } else {
      await api("/categorias", {
        method: "POST",
        body: JSON.stringify(cuerpo),
      });
    }

    cerrarModalCategoria();
    await cargarCategorias();
  } catch (err) {
    el.categoriaError.textContent = err.message;
    el.categoriaError.hidden = false;
  } finally {
    el.botonGuardarCategoria.disabled = false;
    el.botonGuardarCategoria.textContent = "Guardar";
  }
});

// Eliminar categoría
async function eliminarCategoria(cat) {
  const confirmado = confirm(
    `¿Eliminar la categoría "${cat.nombre}"? Si tiene subcategorías o productos asociados, la operación será rechazada.`
  );
  if (!confirmado) return;

  try {
    await api(`/categorias/${cat.id}`, { method: "DELETE" });
    await cargarCategorias();
  } catch (err) {
    alert("Error al eliminar: " + err.message);
  }
}

/* =====================================================
   PRODUCTOS
   ===================================================== */

async function cargarProductos() {
  el.estadoProductos.textContent = "Cargando…";
  el.estadoProductos.hidden = false;
  el.estadoProductos.classList.remove("admin-estado--error");
  el.tablaProductos.hidden = true;

  try {
    productosCache = await api("/productos");
    renderizarProductos(productosCache);
    el.estadoProductos.hidden = true;
    el.tablaProductos.hidden = false;
  } catch (err) {
    el.estadoProductos.textContent = "Error: " + err.message;
    el.estadoProductos.classList.add("admin-estado--error");
  }
}

function renderizarProductos(productos) {
  el.cuerpoProductos.innerHTML = "";

  if (productos.length === 0) {
    el.estadoProductos.textContent = "No hay productos todavía.";
    el.estadoProductos.hidden = false;
    el.tablaProductos.hidden = true;
    return;
  }

  productos.forEach((p) => {
    const tr = document.createElement("tr");

    const tdNombre = document.createElement("td");
    tdNombre.textContent = p.nombre;
    tr.append(tdNombre);

    const tdDesc = document.createElement("td");
    tdDesc.textContent = p.descripcion || "—";
    tr.append(tdDesc);

    const tdCats = document.createElement("td");
    const wrap = document.createElement("div");
    wrap.className = "admin-tabla__categorias";
    const cats = p.categorias_nombres || p.categorias || [];
    if (Array.isArray(cats) && cats.length > 0) {
      cats.forEach((c) => {
        const tag = document.createElement("span");
        tag.className = "admin-tabla__tag";
        tag.textContent = typeof c === "string" ? c : c.nombre;
        wrap.append(tag);
      });
    } else {
      wrap.textContent = "—";
    }
    tdCats.append(wrap);
    tr.append(tdCats);

    const tdAcc = document.createElement("td");
    tdAcc.className = "admin-tabla__acciones";

    const btnEditar = document.createElement("button");
    btnEditar.type = "button";
    btnEditar.className = "admin-boton admin-boton--mini";
    btnEditar.textContent = "Editar";
    btnEditar.addEventListener("click", () => abrirModalEditar(p));
    tdAcc.append(btnEditar);

    const btnEliminar = document.createElement("button");
    btnEliminar.type = "button";
    btnEliminar.className = "admin-boton admin-boton--mini admin-boton--peligro";
    btnEliminar.textContent = "Eliminar";
    btnEliminar.style.marginLeft = "0.3rem";
    btnEliminar.addEventListener("click", () => eliminarProducto(p));
    tdAcc.append(btnEliminar);

    tr.append(tdAcc);
    el.cuerpoProductos.append(tr);
  });
}

// -------- Modal producto --------

function abrirModalNuevo() {
  el.modalTitulo.textContent = "Nuevo producto";
  el.formProducto.reset();
  el.productoId.value = "";
  el.productoError.hidden = true;
  el.productoImagen.value = "";
  el.nombreArchivo.textContent = "Sin archivo";
  el.previewImagen.hidden = true;
  renderizarCheckboxesCategorias();
  el.modalProducto.hidden = false;
  el.productoNombre.focus();
}

function abrirModalEditar(producto) {
  el.modalTitulo.textContent = "Editar producto";
  el.productoId.value = producto.id;
  el.productoNombre.value = producto.nombre || "";
  el.productoDescripcion.value = producto.descripcion || "";
  el.productoAtributos.value = producto.atributos
    ? JSON.stringify(producto.atributos, null, 2)
    : "";
  el.productoError.hidden = true;

  el.productoImagen.value = "";
  el.nombreArchivo.textContent = producto.imagen_url ? "(imagen actual)" : "Sin archivo";

  if (producto.imagen_url) {
    el.previewImagen.src = `/${producto.imagen_url}`;
    el.previewImagen.hidden = false;
  } else {
    el.previewImagen.hidden = true;
  }

  const seleccionadas = (producto.categorias || []).map((c) =>
    typeof c === "object" ? c.id : c
  );
  renderizarCheckboxesCategorias(seleccionadas);

  el.modalProducto.hidden = false;
  el.productoNombre.focus();
}

function cerrarModal() {
  el.modalProducto.hidden = true;
}

el.botonNuevoProducto.addEventListener("click", abrirModalNuevo);
el.botonCancelar.addEventListener("click", cerrarModal);
el.modalFondo.addEventListener("click", cerrarModal);
document.addEventListener("keydown", (e) => {
  if (e.key === "Escape" && !el.modalProducto.hidden) cerrarModal();
});

// -------- Subida de imagen --------

el.botonSubir.addEventListener("click", () => el.productoImagen.click());

el.productoImagen.addEventListener("change", () => {
  const file = el.productoImagen.files[0];
  if (!file) {
    el.nombreArchivo.textContent = "Sin archivo";
    el.previewImagen.hidden = true;
    return;
  }
  el.nombreArchivo.textContent = file.name;
  const reader = new FileReader();
  reader.onload = (e) => {
    el.previewImagen.src = e.target.result;
    el.previewImagen.hidden = false;
  };
  reader.readAsDataURL(file);
});

async function subirImagen(file) {
  const formData = new FormData();
  formData.append("imagen", file);

  const resp = await fetch(`${API}/upload`, {
    method: "POST",
    headers: token ? { Authorization: `Bearer ${token}` } : {},
    body: formData,
  });

  const data = await resp.json();
  if (!resp.ok) throw new Error(data.error || "Error al subir la imagen.");
  return data.url;
}

// -------- Guardar producto --------

el.formProducto.addEventListener("submit", async (e) => {
  e.preventDefault();
  el.productoError.hidden = true;
  el.botonGuardar.disabled = true;
  el.botonGuardar.textContent = "Guardando…";

  try {
    const id = el.productoId.value;

    let imagenUrl = null;
    const file = el.productoImagen.files[0];
    if (file) {
      el.botonGuardar.textContent = "Subiendo imagen…";
      imagenUrl = await subirImagen(file);
    } else if (id) {
      const productoActual = productosCache.find((p) => String(p.id) === String(id));
      imagenUrl = productoActual?.imagen_url || null;
    }

    let atributos = null;
    const atributosTexto = el.productoAtributos.value.trim();
    if (atributosTexto) {
      try {
        atributos = JSON.parse(atributosTexto);
      } catch {
        throw new Error("El JSON de atributos no es válido.");
      }
    }

    const categorias = Array.from(
      el.categoriasProducto.querySelectorAll("input[type=checkbox]:checked")
    ).map((c) => parseInt(c.value, 10));

    const cuerpo = {
      nombre: el.productoNombre.value.trim(),
      descripcion: el.productoDescripcion.value.trim() || null,
      imagen_url: imagenUrl,
      atributos,
      categorias,
    };

    if (!cuerpo.nombre) throw new Error("El nombre es obligatorio.");

    el.botonGuardar.textContent = "Guardando…";

    if (id) {
      await api(`/productos/${id}`, {
        method: "PUT",
        body: JSON.stringify(cuerpo),
      });
    } else {
      await api("/productos", {
        method: "POST",
        body: JSON.stringify(cuerpo),
      });
    }

    cerrarModal();
    await cargarProductos();
  } catch (err) {
    el.productoError.textContent = err.message;
    el.productoError.hidden = false;
  } finally {
    el.botonGuardar.disabled = false;
    el.botonGuardar.textContent = "Guardar";
  }
});

// -------- Eliminar producto --------

async function eliminarProducto(producto) {
  const confirmado = confirm(
    `¿Eliminar el producto "${producto.nombre}"? Esta acción no se puede deshacer.`
  );
  if (!confirmado) return;

  try {
    await api(`/productos/${producto.id}`, { method: "DELETE" });
    await cargarProductos();
  } catch (err) {
    alert("Error al eliminar: " + err.message);
  }
}

/* =====================================================
   PESTAÑAS
   ===================================================== */

const tabs = document.querySelectorAll(".admin-tab");
const secciones = {
  productos: document.getElementById("seccionProductos"),
  categorias: document.getElementById("seccionCategorias"),
};

tabs.forEach((tab) => {
  tab.addEventListener("click", () => {
    const destino = tab.dataset.tab;

    tabs.forEach((t) => t.classList.toggle("admin-tab--activo", t === tab));

    Object.entries(secciones).forEach(([nombre, seccion]) => {
      seccion.hidden = nombre !== destino;
    });
  });
});

/* =====================================================
   ARRANQUE
   ===================================================== */

init();