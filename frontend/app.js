/* =====================================================================
   Catálogo Digital — Papelería San Carlos
   RF-01 / RF-07  catálogo de productos agrupado por categorías
   RF-05          banner de anuncios destacados
   RF-08          las categorías de temporada solo llegan si están activas
   RF-11          submenú: filtrar el catálogo por categoría
   RF-13          barra lateral con el ícono de cada categoría
   Navegación: barra lateral de 2 niveles + panel principal con
   subcategorías como tarjetas (para árboles profundos).
   Nunca se piden ni se muestran precio ni stock (RF-03, RF-04).
   ===================================================================== */

const API = "http://localhost:3000/api";

const elementos = {
  listaCategorias: document.getElementById("listaCategorias"),
  migas: document.getElementById("migas"),
  subcategorias: document.getElementById("subcategorias"),
  rejilla: document.getElementById("rejillaProductos"),
  estado: document.getElementById("estadoCatalogo"),
  titulo: document.getElementById("tituloCatalogo"),
  conteo: document.getElementById("conteoProductos"),
  banner: document.getElementById("banner"),
  bannerPista: document.getElementById("bannerPista"),
  bannerPuntos: document.getElementById("bannerPuntos"),
  bannerAnterior: document.getElementById("bannerAnterior"),
  bannerSiguiente: document.getElementById("bannerSiguiente"),
    campoBusqueda: document.getElementById("campoBusqueda"),
  limpiarBusqueda: document.getElementById("limpiarBusqueda"),
};

let categoriaActiva = null;      // null = todo el catálogo
let busquedaActiva = "";
let productosCache = [];
let cacheListo = false;
let categoriasArbol = [];        // árbol completo en memoria

/* ------------------------------ Utilidades -------------------------- */

async function pedir(ruta) {
  const respuesta = await fetch(`${API}${ruta}`);
  if (!respuesta.ok) throw new Error(`La petición a ${ruta} respondió ${respuesta.status}`);
  return respuesta.json();
}

function mostrarEstado(texto, esError = false) {
  elementos.estado.textContent = texto;
  elementos.estado.hidden = !texto;
  elementos.estado.classList.toggle("estado--error", esError);
}

// Busca una categoría por id en el árbol y devuelve la categoría + el
// camino desde la raíz hasta ella. El camino es lo que alimenta las migas.
function buscarCategoriaPorId(id, arbol = categoriasArbol, camino = []) {
  for (const cat of arbol) {
    const nuevoCamino = [...camino, cat];
    if (cat.id === id) return { categoria: cat, camino: nuevoCamino };
    if (Array.isArray(cat.hijos) && cat.hijos.length > 0) {
      const resultado = buscarCategoriaPorId(id, cat.hijos, nuevoCamino);
      if (resultado) return resultado;
    }
  }
  return null;
}

/* ------------------- Categorías: barra lateral ---------------------- */

async function cargarCategorias() {
  try {
    categoriasArbol = await pedir("/categorias");
  } catch (error) {
    elementos.listaCategorias.innerHTML =
      '<li class="categorias__cargando">No se pudieron cargar las categorías.</li>';
    return;
  }

  renderizarSidebar();
}

// La barra lateral solo muestra hasta 2 niveles (raíces + sus hijos
// directos). Los niveles más profundos se navegan desde el panel principal.
function renderizarSidebar() {
  elementos.listaCategorias.innerHTML = "";
  elementos.listaCategorias.append(
    crearNodoSidebar({ id: null, nombre: "Todo el catálogo", icono: "★", hijos: [] }, 0)
  );
  categoriasArbol.forEach((categoria) => {
    elementos.listaCategorias.append(crearNodoSidebar(categoria, 0));
  });
  marcarCategoriaActiva();
}

const MAPA_ICONOS = {
  cuaderno: "📓",
  carpeta: "📁",
  paleta: "🎨",
  fantasma: "👻",
  estrella: "⭐",
  lapiz: "✏️",
  lápiz: "✏️",
  papel: "📄",
  regalo: "🎁",
};

function resolverIcono(categoria) {
  const valor = (categoria.icono || "").trim();
  if (!valor) return categoria.nombre.charAt(0).toUpperCase();
  if (valor.length <= 2) return valor;
  return MAPA_ICONOS[valor.toLowerCase()] || categoria.nombre.charAt(0).toUpperCase();
}

function crearNodoSidebar(categoria, nivel) {
  const item = document.createElement("li");
  item.className = "categoria-nodo";

  const fila = document.createElement("div");
  fila.className = "categoria-fila";
  fila.style.setProperty("--nivel", nivel);

  const tieneHijos = Array.isArray(categoria.hijos) && categoria.hijos.length > 0;
  // Solo mostramos un nivel de profundidad en la barra lateral.
  const mostrarHijos = tieneHijos && nivel < 1;

  if (mostrarHijos) {
    const toggle = document.createElement("button");
    toggle.type = "button";
    toggle.className = "categoria__toggle";
    toggle.setAttribute("aria-expanded", "false");
    toggle.setAttribute("aria-label", `Mostrar subcategorías de ${categoria.nombre}`);
    toggle.textContent = "›";
    toggle.addEventListener("click", () => {
      const abierto = toggle.getAttribute("aria-expanded") === "true";
      toggle.setAttribute("aria-expanded", String(!abierto));
      sublista.hidden = abierto;
    });
    fila.append(toggle);
  } else {
    const espaciador = document.createElement("span");
    espaciador.className = "categoria__toggle categoria__toggle--vacio";
    espaciador.setAttribute("aria-hidden", "true");
    fila.append(espaciador);
  }

  const boton = document.createElement("button");
  boton.type = "button";
  boton.className = "categoria";
  boton.dataset.id = categoria.id ?? "";

  if (nivel === 0) {
    const icono = document.createElement("span");
    icono.className = "categoria__icono";
    icono.setAttribute("aria-hidden", "true");
    icono.textContent = resolverIcono(categoria);
    boton.append(icono);
  }

  const etiqueta = document.createElement("span");
  etiqueta.className = "categoria__etiqueta";
  etiqueta.textContent = categoria.nombre;
  boton.append(etiqueta);

  if (categoria.tipo === "temporada") {
    const distintivo = document.createElement("span");
    distintivo.className = "categoria__temporada";
    distintivo.textContent = "Temporada";
    boton.append(distintivo);
  }

  boton.addEventListener("click", () => seleccionarCategoria(categoria.id ?? null));

  fila.append(boton);
  item.append(fila);

  let sublista;
  if (mostrarHijos) {
    sublista = document.createElement("ul");
    sublista.className = "categoria__hijos";
    sublista.hidden = true;
    categoria.hijos.forEach((hijo) => {
      sublista.append(crearNodoSidebar(hijo, nivel + 1));
    });
    item.append(sublista);
  }

  return item;
}

function marcarCategoriaActiva() {
  if (busquedaActiva) {
    // En modo búsqueda, ninguna categoría está activa
    elementos.listaCategorias.querySelectorAll(".categoria").forEach((boton) => {
      boton.setAttribute("aria-current", "false");
    });
    return;
  }
  const valorActivo = categoriaActiva === null ? "" : String(categoriaActiva);
  elementos.listaCategorias.querySelectorAll(".categoria").forEach((boton) => {
    boton.setAttribute("aria-current", String(boton.dataset.id === valorActivo));
  });
}

/* ------------------- Navegación y panel principal ------------------- */

function seleccionarCategoria(id) {
  if (busquedaActiva) {
    busquedaActiva = "";
    elementos.campoBusqueda.value = "";
    elementos.limpiarBusqueda.hidden = true;
  }
  categoriaActiva = id;
  marcarCategoriaActiva();
  actualizarTitulo();
  actualizarMigas();
  renderizarSubcategorias();
  cargarProductos();
}

function actualizarTitulo() {
  if (categoriaActiva === null) {
    elementos.titulo.textContent = "Todo el catálogo";
    return;
  }
  const encontrado = buscarCategoriaPorId(categoriaActiva);
  elementos.titulo.textContent = encontrado ? encontrado.categoria.nombre : "Todo el catálogo";
}

function actualizarMigas() {
  elementos.migas.innerHTML = "";

  const crearEnlace = (texto, id) => {
    const btn = document.createElement("button");
    btn.type = "button";
    btn.className = "migas__enlace";
    btn.textContent = texto;
    btn.addEventListener("click", () => seleccionarCategoria(id));
    return btn;
  };

  const crearSeparador = () => {
    const sep = document.createElement("span");
    sep.className = "migas__sep";
    sep.setAttribute("aria-hidden", "true");
    sep.textContent = "/";
    return sep;
  };

  const crearActual = (texto) => {
    const span = document.createElement("span");
    span.className = "migas__actual";
    span.setAttribute("aria-current", "page");
    span.textContent = texto;
    return span;
  };

  // Caso: Todo el catálogo
  if (categoriaActiva === null) {
    elementos.migas.append(crearActual("Todo el catálogo"));
    return;
  }

  const encontrado = buscarCategoriaPorId(categoriaActiva);
  if (!encontrado) {
    elementos.migas.append(crearActual("Todo el catálogo"));
    return;
  }

  // Primer crumb siempre clickeable (excepto si fuera el actual, que no lo es).
  elementos.migas.append(crearEnlace("Todo el catálogo", null));

  encontrado.camino.forEach((cat, i) => {
    elementos.migas.append(crearSeparador());
    if (i === encontrado.camino.length - 1) {
      elementos.migas.append(crearActual(cat.nombre));
    } else {
      elementos.migas.append(crearEnlace(cat.nombre, cat.id));
    }
  });
}

function renderizarSubcategorias() {
  elementos.subcategorias.innerHTML = "";

  if (categoriaActiva === null) {
    elementos.subcategorias.hidden = true;
    return;
  }

  const encontrado = buscarCategoriaPorId(categoriaActiva);
  const hijos = encontrado?.categoria.hijos || [];

  if (hijos.length === 0) {
    elementos.subcategorias.hidden = true;
    return;
  }

  hijos.forEach((hijo) => {
    const item = document.createElement("li");

    const boton = document.createElement("button");
    boton.type = "button";
    boton.className = "subcategoria";

    const icono = document.createElement("span");
    icono.className = "subcategoria__icono";
    icono.setAttribute("aria-hidden", "true");
    icono.textContent = hijo.nombre.charAt(0).toUpperCase();
    boton.append(icono);

    const nombre = document.createElement("span");
    nombre.className = "subcategoria__nombre";
    nombre.textContent = hijo.nombre;
    boton.append(nombre);

    if (hijo.tipo === "temporada") {
      const distintivo = document.createElement("span");
      distintivo.className = "subcategoria__temporada";
      distintivo.textContent = "Temporada";
      boton.append(distintivo);
    }

    const flecha = document.createElement("span");
    flecha.className = "subcategoria__flecha";
    flecha.setAttribute("aria-hidden", "true");
    flecha.textContent = "›";
    boton.append(flecha);

    boton.addEventListener("click", () => seleccionarCategoria(hijo.id));
    item.append(boton);
    elementos.subcategorias.append(item);
  });

  elementos.subcategorias.hidden = false;
}

/* ------------------------- Catálogo de productos -------------------- */

async function cargarProductos() {
  elementos.rejilla.innerHTML = "";
  mostrarEstado("Cargando productos…");
  elementos.conteo.textContent = "";

  const ruta = categoriaActiva === null
    ? "/productos"
    : `/productos?categoria=${encodeURIComponent(categoriaActiva)}`;

  let productos;
  try {
    productos = await pedir(ruta);
  } catch (error) {
    mostrarEstado("No se pudo cargar el catálogo.", true);
    return;
  }

  if (productos.length === 0) {
    mostrarEstado(
      categoriaActiva === null
        ? "Todavía no hay productos en el catálogo."
        : "Esta categoría todavía no tiene productos."
    );
    return;
  }

  mostrarEstado("");
  elementos.conteo.textContent =
    productos.length === 1 ? "1 producto" : `${productos.length} productos`;
  productos.forEach((producto) => elementos.rejilla.append(crearTarjetaProducto(producto)));
}

function crearTarjetaProducto(producto) {
  const item = document.createElement("li");
  item.className = "producto";

  const lamina = document.createElement("div");
  lamina.className = "producto__lamina";
  if (producto.imagen_url) {
    const imagen = document.createElement("img");
    imagen.src = producto.imagen_url;
    imagen.alt = producto.nombre;
    imagen.loading = "lazy";
    lamina.append(imagen);
  } else {
    const inicial = document.createElement("span");
    inicial.className = "producto__inicial";
    inicial.setAttribute("aria-hidden", "true");
    inicial.textContent = producto.nombre.charAt(0).toUpperCase();
    lamina.append(inicial);
  }

  const cuerpo = document.createElement("div");
  cuerpo.className = "producto__cuerpo";

  const nombre = document.createElement("h3");
  nombre.className = "producto__nombre";
  nombre.textContent = producto.nombre;
  cuerpo.append(nombre);

  if (producto.descripcion) {
    const descripcion = document.createElement("p");
    descripcion.className = "producto__descripcion";
    descripcion.textContent = producto.descripcion;
    cuerpo.append(descripcion);
  }

  item.append(lamina, cuerpo);
  return item;
}

/* ------------------------- Motor de búsqueda ------------------------ */

// Normaliza texto: minúsculas + sin tildes.
// "Lápices" -> "lapices"  |  "Grafitos" -> "grafitos"
function normalizar(texto) {
  return String(texto || "")
    .toLowerCase()
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "");
}

// Precarga todos los productos en segundo plano para poder buscar sin
// ir al servidor en cada tecla. Si falla, la búsqueda puntual seguirá
// funcionando vía API cuando se implemente el fallback.
async function precargarProductos() {
  try {
    productosCache = await pedir("/productos");
    cacheListo = true;
  } catch (error) {
    cacheListo = false;
  }
}

function debounce(fn, ms) {
  let temporizador;
  return (...args) => {
    clearTimeout(temporizador);
    temporizador = setTimeout(() => fn(...args), ms);
  };
}

// Devuelve los productos que cumplen TODOS los términos de búsqueda.
// Busca sobre nombre, descripción y atributos (JSON serializado).
function filtrarProductos(termino) {
  const t = normalizar(termino).trim();
  if (!t) return productosCache;

  const terminos = t.split(/\s+/).filter(Boolean);

  return productosCache.filter((p) => {
    const campos = [
      normalizar(p.nombre),
      normalizar(p.descripcion),
      p.atributos ? normalizar(JSON.stringify(p.atributos)) : "",
    ].join(" ");
    return terminos.every((term) => campos.includes(term));
  });
}

function actualizarVistaBusqueda() {
  // Sin búsqueda: vuelve a la vista normal por categoría
  if (!busquedaActiva) {
    actualizarTitulo();
    actualizarMigas();
    renderizarSubcategorias();
    cargarProductos();
    return;
  }

  // Vista de búsqueda: título, sin migas, sin subcategorías, sin categoría activa
  elementos.titulo.textContent = `Resultados para: "${busquedaActiva}"`;
  elementos.migas.innerHTML = "";
  elementos.subcategorias.hidden = true;
  elementos.subcategorias.innerHTML = "";
  marcarCategoriaActiva();

  if (!cacheListo) {
    mostrarEstado("Cargando catálogo para buscar…");
    return;
  }

  const resultados = filtrarProductos(busquedaActiva);
  elementos.rejilla.innerHTML = "";

  if (resultados.length === 0) {
    elementos.conteo.textContent = "";
    mostrarEstado(`No se encontraron productos para "${busquedaActiva}".`);
    return;
  }

  mostrarEstado("");
  elementos.conteo.textContent =
    resultados.length === 1
      ? "1 producto encontrado"
      : `${resultados.length} productos encontrados`;
  resultados.forEach((p) => elementos.rejilla.append(crearTarjetaProducto(p)));
}

const manejarBusqueda = debounce((valor) => {
  busquedaActiva = valor.trim();
  actualizarVistaBusqueda();
}, 150);

elementos.campoBusqueda.addEventListener("input", (e) => {
  const valor = e.target.value;
  elementos.limpiarBusqueda.hidden = valor === "";
  manejarBusqueda(valor);
});

elementos.campoBusqueda.addEventListener("keydown", (e) => {
  if (e.key === "Escape") {
    elementos.campoBusqueda.value = "";
    elementos.limpiarBusqueda.hidden = true;
    manejarBusqueda("");
  }
});

elementos.limpiarBusqueda.addEventListener("click", () => {
  elementos.campoBusqueda.value = "";
  elementos.limpiarBusqueda.hidden = true;
  manejarBusqueda("");
  elementos.campoBusqueda.focus();
});

/* --------------------- Banner de anuncios (RF-05) ------------------- */

const banner = { laminas: [], indice: 0, temporizador: null };

async function cargarBanner() {
  let anuncios;
  try {
    anuncios = await pedir("/banners");
  } catch (error) {
    return;
  }
  if (anuncios.length === 0) return;

  banner.laminas = anuncios;
  elementos.banner.hidden = false;

  anuncios.forEach((anuncio, posicion) => {
    const lamina = document.createElement("li");
    lamina.className = "banner__lamina";
    const imagen = document.createElement("img");
    imagen.src = anuncio.imagen_url;
    imagen.alt = `Anuncio ${posicion + 1} de ${anuncios.length}`;
    lamina.append(imagen);
    elementos.bannerPista.append(lamina);

    const itemPunto = document.createElement("li");
    const punto = document.createElement("button");
    punto.type = "button";
    punto.className = "banner__punto";
    punto.setAttribute("aria-label", `Ver anuncio ${posicion + 1}`);
    punto.addEventListener("click", () => irA(posicion));
    itemPunto.append(punto);
    elementos.bannerPuntos.append(itemPunto);
  });

  elementos.bannerAnterior.addEventListener("click", () => irA(banner.indice - 1));
  elementos.bannerSiguiente.addEventListener("click", () => irA(banner.indice + 1));

  irA(0);
  iniciarAvanceAutomatico();
}

function irA(posicion) {
  const total = banner.laminas.length;
  banner.indice = (posicion + total) % total;
  elementos.bannerPista.style.transform = `translateX(-${banner.indice * 100}%)`;
  elementos.bannerPuntos.querySelectorAll(".banner__punto").forEach((punto, i) => {
    punto.setAttribute("aria-current", String(i === banner.indice));
  });
  iniciarAvanceAutomatico();
}

function iniciarAvanceAutomatico() {
  clearInterval(banner.temporizador);
  const prefiereMenosMovimiento = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
  if (prefiereMenosMovimiento || banner.laminas.length < 2) return;
  banner.temporizador = setInterval(() => irA(banner.indice + 1), 6000);
}

/* ------------------------------ Arranque ---------------------------- */

cargarCategorias();
cargarProductos();
cargarBanner();
precargarProductos();