<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="jakarta.servlet.http.Cookie" %>
<%@ page import="java.util.UUID" %>
<%@ page import="datos.Mantenimiento" %>
<%@ page import="dao.IMantenimiento" %>
<html lang="en">

    <head>
        <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Ace Time</title>
                <link rel="stylesheet" href="https://cdn.tailwindcss.com">
                    <link href="./output.css" rel="stylesheet" />
                    <link rel="stylesheet"
                          href="https://cdn-uicons.flaticon.com/2.3.0/uicons-regular-rounded/css/uicons-regular-rounded.css" />
                    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
                        <link href="https://cdn.jsdelivr.net/npm/daisyui@4.12.2/dist/full.min.css" rel="stylesheet" type="text/css" />
                        <script src="https://cdn.tailwindcss.com"></script>

                        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css" />
                        <link rel='stylesheet' href='https://cdn-uicons.flaticon.com/2.4.0/uicons-regular-rounded/css/uicons-regular-rounded.css'>
                            <style>
                                .slider-wrapper {
                                    overflow: hidden;
                                    position: relative;
                                    width: 80%; /* Adjust as needed */
                                    margin: 0 auto;
                                }
                                .slider {
                                    display: flex;
                                    transition: transform 0.3s ease-in-out;
                                }
                                .slider-item {
                                    flex: 0 0 25%;
                                    box-sizing: border-box;
                                    margin-right: 16px;
                                }


                                @media (max-width: 1024px) {
                                    .slider-item {
                                        flex: 0 0 33.3333%;
                                    }
                                }
                                @media (max-width: 768px) {
                                    .slider-item {
                                        flex: 0 0 50%;
                                    }
                                }
                                @media (max-width: 640px) {
                                    .slider-item {
                                        flex: 0 0 100%;
                                    }
                                }
                            </style>
                            </head>
                            <body >
                                <%
                                // Obtener la ID de sesión desde la cookie
                                String sesion_id = null;
                                Cookie[] cookies = request.getCookies();
                                if (cookies != null) {
                                    for (Cookie cookie : cookies) {
                                        if ("sesion_id".equals(cookie.getName())) {
                                            sesion_id = cookie.getValue();
                                            break;
                                        }
                                    }
                                }

                                // Si no se encuentra la ID de sesión en la cookie, generamos una nueva
                                if (sesion_id == null || sesion_id.isEmpty()) {
                                    sesion_id = UUID.randomUUID().toString(); // Generar una nueva ID de sesión
                                    Cookie cookie = new Cookie("sesion_id", sesion_id);
                                    response.addCookie(cookie);
                                }

                                // Obtener el idUsuario de la sesión
                                Integer idUsuario = (Integer) session.getAttribute("idUsuario");

                                // Realizar la consulta SQL
                                int totalProductos = 0;
                                int CostoTotal = 0;
                                Mantenimiento mantenimiento = new Mantenimiento();
                                mantenimiento.conectarBD();
                                Connection conn = mantenimiento.getConexion();

                                PreparedStatement stmt = null;
                                ResultSet rs = null;

                                try {
                                    if (idUsuario != null) {
                                        // Si hay un idUsuario en la sesión, usarlo para la consulta
                                        stmt = conn.prepareStatement("SELECT SUM(precio * cantidad) AS costo_total, SUM(cantidad) AS total_productos FROM carrito WHERE id_usuario = ?");
                                        stmt.setInt(1, idUsuario);
                                    } else {
                                        // Si no hay idUsuario en la sesión, usar sesion_id para la consulta
                                        stmt = conn.prepareStatement("SELECT SUM(precio * cantidad) AS costo_total, SUM(cantidad) AS total_productos FROM carrito WHERE sesion_id = ?");
                                        stmt.setString(1, sesion_id);
                                    }

                                    rs = stmt.executeQuery();
                                    if (rs.next()) {
                                        totalProductos = rs.getInt("total_productos");
                                        CostoTotal = rs.getInt("costo_total");
                                    }
                                } catch (Exception e) {
                                    e.printStackTrace();
                                } finally {
                                    try {
                                        if (rs != null) rs.close();
                                        if (stmt != null) stmt.close();
                                        mantenimiento.cerrarBD();
                                    } catch (Exception e) {
                                        e.printStackTrace();
                                    }
                                }
                                %>
                                <body>
                                    <nav class="bg-gray-100 fixed top-0 left-0 w-full z-50">
                                        <div class="bg-gray-100 font-sans w-full min-h-0 m-0">
                                            <div class="bg-gray-100">
                                                <div class="container mx-auto px-0">
                                                    <div class="flex items-center justify-between py-4">
                                                        <div class="flex items-center ml-2 ">
                                                            <a href="#" class="flex items-center py-0 px-0 text-gray-700 hover:text-gray-900">
                                                                <img src="./img/ace.png" alt="Logo" class="w-24 h-auto" />
                                                            </a>
                                                            <div class="hidden sm:flex sm:items-start ml-8"></div>
                                                            <div class="hidden sm:flex sm:items-center">
                                                                <a href="index.jsp" class="text-gray-800 text-base font-semibold hover:text-yellow-600 mr-4 hidden sm:inline">Inicio</a>
                                                                <a href="productos.jsp" class="text-gray-800 text-base font-semibold hover:text-yellow-600 mr-4 hidden sm:inline">Productos</a>
                                                                <a href="nosotros.jsp" class="text-gray-800 text-base font-semibold hover:text-yellow-600 mr-4 hidden sm:inline">Nosotros</a>
                                                                <a href="contactos.jsp" class="text-gray-800 text-base font-semibold hover:text-yellow-600 mr-4 hidden sm:inline">Contactos</a>
                                                            </div>
                                                        </div>
                                                        <div class="hidden sm:flex sm:items-center" id="signInUp">
                                                            <div class="dropdown dropdown-end">
                                                                <div tabindex="0" role="button" class="btn btn-ghost btn-circle">
                                                                    <div class="indicator">
                                                                        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z" /></svg>
                                                                        <span class="badge badge-xl indicator-item bg-yellow-400 text-white"><%= totalProductos %></span>
                                                                    </div>
                                                                </div>
                                                                <div tabindex="0" class="mt-3 z-50 card card-compact dropdown-content w-52 bg-base-100 shadow">
                                                                    <div class="card-body">
                                                                        <span class="font-bold text-lg"><%= totalProductos %> Productos</span>
                                                                        <span class="text-yellow-600">Subtotal: S/ <%= CostoTotal %></span>
                                                                        <div class="card-actions">
                                                                            <button class="btn btn-sm btn-warning btn-block text-white" onclick="window.location.href = 'carito.jsp';">Ver Carrito</button>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="mr-4">
                                                                <svg width="25" height="25">
                                                                    <line x1="12.5" y1="0" x2="12.5" y2="25" stroke="black" stroke-width="2" />
                                                                </svg>
                                                            </div>
                                                            <% 
                                            // Verificar si hay una sesión activa
                                            HttpSession sesion = request.getSession(false);
                                            if (session.getAttribute("nombreUsuario") != null) { 
                                                // Si hay una sesión activada
                                                if ("admin".equals(sesion.getAttribute("rol"))) { 
                                                            %>
                                                            <div class="dropdown dropdown-end">
                                                                <div>
                                                                    <div class="indicator">
                                                                        <span class="text-gray-500">Hola, <span class="font-bold"><%= session.getAttribute("nombreUsuario") %></span></span>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="dropdown dropdown-end">
                                                                <div tabindex="0" role="button" class="btn btn-ghost btn-circle avatar">
                                                                    <div class="w-10 rounded-full">
                                                                        <img alt="avatar" src="img/avatar.png" />
                                                                    </div>
                                                                </div>
                                                                <ul tabindex="0" class="menu menu-sm dropdown-content mt-3 z-[1] p-2 shadow bg-base-100 rounded-box w-52">
                                                                    <li><a href="CambioRol.jsp"> <i class="fi fi-rr-convert-shapes"></i> Cambiar Rol</a></li>
                                                                    <li><a href="cerrarsesion.jsp"> <i class="fi fi-rr-exit"></i> Cerrar Sesion</a></li>
                                                                </ul>
                                                            </div>
                                                            <% 
                                                                } else if ("cliente".equals(sesion.getAttribute("rol"))) {
                                                            %>
                                                            <div class="dropdown dropdown-end">
                                                                <div>
                                                                    <div class="indicator">
                                                                        <span class="text-gray-500">Hola, <span class="font-bold"><%= session.getAttribute("nombreUsuario") %></span></span>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="dropdown dropdown-end">
                                                                <div tabindex="0" role="button" class="btn btn-ghost btn-circle avatar">
                                                                    <div class="w-10 rounded-full">
                                                                        <img alt="avatar" src="img/avatar.png" />
                                                                    </div>
                                                                </div>
                                                                <ul tabindex="0" class="menu menu-sm dropdown-content mt-3 z-[1] p-2 shadow bg-base-100 rounded-box w-52">
                                                                    <li><a href="AjustesUsuario.jsp"> <i class="fi fi-rr-admin-alt"></i> Cuenta</a></li>
                                                                    <li><a href="cerrarsesion.jsp"> <i class="fi fi-rr-exit"></i> Cerrar Sesion</a></li>
                                                                </ul>
                                                            </div> 
                                                            <% 
                                                                }
                                                            } else {
                                                            %>
                                                            <div class="dropdown dropdown-end">
                                                                <div>
                                                                    <div class="indicator">
                                                                        <span class="text-gray-500 cursor-pointer hover:underline"><a id="openModal">  Iniciar Sesion</a></span>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="dropdown dropdown-end">
                                                                <div tabindex="0" role="button" class="btn btn-ghost btn-circle avatar">
                                                                    <div class="w-10 rounded-full">
                                                                        <img alt="avatar" src="img/avatar.png" />
                                                                    </div>
                                                                </div>
                                                            </div> 
                                                            <% 
                                                            }
                                                            %>
                                                        </div>
                                                        <div class="sm:hidden cursor-pointer" id="mobileMenuButton">
                                                            <i class="fi fi-rr-menu-burger text-4xl mx-6"></i>
                                                        </div>
                                                    </div>
                                                    <div class="sm:hidden bg-white border-t-2 py-2 hidden " id="mobileMenu">
                                                        <div class="flex flex-col">
                                                            <a href="index.jsp" class="text-gray-800 text-base font-semibold hover:text-yellow-600 mb-1 mx-5  ">Inicio</a>
                                                            <a href="productos.jsp" class="text-gray-800 text-base font-semibold hover:text-yellow-600 mb-1 mx-5   ">Productos</a>
                                                            <a href="nosotros.jsp" class="text-gray-800 text-base font-semibold hover:text-yellow-600 mb-1 mx-5 ">Nosotros</a>
                                                            <a href="contactos.jsp" class="text-gray-800 text-base font-semibold hover:text-yellow-600 mb-1 mx-5 ">Contactos</a>
                                                            <div class="mx-5 mt-2 mb-2 border-t border-gray-300"></div> 
                                                            <% 
                                         if (session.getAttribute("nombreUsuario") != null) { 
                                             if ("admin".equals(sesion.getAttribute("rol"))) { 
                                                            %>
                                                            <a href="CambioRol.jsp" class="text-gray-800 text-base font-semibold hover:text-yellow-600 mb-1 mx-5" > <i class="fi fi-rr-convert-shapes"></i> Cambiar Rol</a>
                                                            <a href="cerrarsesion.jsp" class="text-gray-800 text-base font-semibold hover:text-yellow-600 mb-1 mx-5" > <i class="fi fi-rr-exit"></i> Cerrar Sesion</a>
                                                            <% 
                                                                } else if ("cliente".equals(sesion.getAttribute("rol"))) {
                                                            %>
                                                            <a href="AjustesUsuario.jsp" class="text-gray-800 text-base font-semibold hover:text-yellow-600 mb-1 mx-5"> <i class="fi fi-rr-admin-alt"></i> Cuenta</a>
                                                            <a href="cerrarsesion.jsp" class="text-gray-800 text-base font-semibold hover:text-yellow-600 mb-1 mx-5" > <i class="fi fi-rr-exit"></i> Cerrar Sesion</a>
                                                            <% 
                                                               }
                                                           } else {
                                                            %>
                                                            <a id="openModal" class="text-gray-800 text-base font-semibold hover:text-yellow-600 mb-1 mx-5"> <i class="fi fi-rr-sign-in-alt"></i> Iniciar Sesion</a>
                                                            <% 
                                                           }
                                                            %>
                                                            <div tabindex="0" role="button" class="btn btn-ghost btn-circle mx-5" onclick="window.location.href = 'carito.jsp';">
                                                                <div class="indicator">
                                                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z" />
                                                                    </svg>
                                                                    <span class="badge badge-xl indicator-item bg-yellow-400 text-white"><%= totalProductos %></span>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </nav>
                                    <div class="container mx-auto px-4 py-8 mt-14">

                                        <div class="grid grid-cols-1 md:grid-cols-2 gap-8">

                                            <div class="bg-white rounded-lg overflow-hidden p-6 justify-center">
                                                <h1 class="mb-4 mt-12 text-6xl font-bold">Descubre nuestra colección exclusiva de relojes</h1>
                                                <p class="text-gray-700 leading-relaxed text-base">
                                                    En nuestra tienda en línea encontrarás una amplia selección de
                                                    relojes de alta calidad, elegantes y modernos. Explora nuestra
                                                    colección y encuentra el reloj perfecto para ti.
                                                </p>
                                                <div class="mt-8 flex flex-wrap justify-start space-x-1">
                                                    <a href="productos.jsp" class="text-white bg-black text-xl font-semibold border px-4 py-2 rounded-lg hover:text-white hover:border-yellow-600 hover:bg-yellow-600 mb-4 md:mb-0">
                                                        Explorar
                                                    </a>
                                                    <a href="#" class="text-yellow-600 bg-white text-xl border-yellow-600 font-semibold border px-4 py-2 rounded-lg hover:text-white hover:border-yellow-600 hover:bg-yellow-600 mb-4 md:mb-0">
                                                        Más información
                                                    </a>
                                                </div>
                                            </div>

                                            <!-- Valores de la empresa -->
                                            <div class="bg-white  p-6  flex justify-center items-center">
                                                <div class="flex items-center py-0 px-0 text-gray-700 hover:text-gray-900 mt-5">
                                                    <img src="img/ace-portada.jpg" alt="Logo" height="700" width="800"/>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <h1 class="text-3xl font-bold text-center mt-8">Productos en tienda</h1>
                                    <div class="bg-yellow-500 h-1 w-24 mx-auto rounded-full border border-yellow-500 mt-2"></div>
                                    <div class="slider-wrapper mt-8 ">
                                        <div id="slider" class="slider">
                                            <%
                                                Connection conexion = null;
                                                PreparedStatement pstmt1 = null;
                                                ResultSet rs1 = null;
                                                try {
                                                    // Crear una instancia de la clase Mantenimiento para manejar la conexión a la base de datos
                                                    Mantenimiento mantenimiento1 = new Mantenimiento();
                                                    mantenimiento1.conectarBD();
                                                    conexion = mantenimiento1.getConexion();

                                                    // Consulta SQL para obtener todos los productos
                                                    String consulta1 = "SELECT P.id_producto, P.descripcion, P.precio, P.cantidad, P.url_imagen, M.id_marca, M.nombre_marca FROM Productos AS P JOIN Marca AS M ON P.marca_id = M.id_marca;";
                                                    pstmt1 = conexion.prepareStatement(consulta1);
                                                    rs1 = pstmt1.executeQuery();

                                                    // Procesar los resultados
                                                    boolean hayProductos = false; // Variable para verificar si hay productos
                                                    while (rs1.next()) {
                                                        hayProductos = true; // Se encontraron productos
                                                        int idProducto = rs1.getInt("id_producto");
                                                        String marca = rs1.getString("nombre_marca");
                                                        String descripcion = rs1.getString("descripcion");
                                                        String precio = rs1.getString("precio");
                                                        int cantidad = rs1.getInt("cantidad");
                                                        String urlImagen = rs1.getString("url_imagen");
                                            %>

                                            <div class="slider-item  p-4 rounded-lg shadow-md text-center">
                                                <a href="producto.jsp?id_producto=<%= idProducto %>">
                                                    <img src="${pageContext.request.contextPath}<%= urlImagen %>" alt="<%= marca  %>" class="transition duration-300 transform hover:scale-105 hover:shadow-yellow-400">
                                                </a>
                                                <div class="mt-2">
                                                    <h2 class="text-lg font-bold"><%= descripcion %></h2>
                                                    <p class=" text-xl stat-value text-yellow-500">S/<%= precio %></p>
                                                </div>

                                                <a href="producto.jsp?id_producto=<%= idProducto %>" class="btn  btn-warning btn-sm text-white mt-2 bg-gradient-to-r from-yellow-500 to-orange-500 text-white w-max rounded-full "><i class="fi fi-rr-shopping-cart"></i>Comprar </a>
                                            </div>


                                            <%
                                                    }
                                                    if (!hayProductos) {
                                            %>
                                            <p>No hay productos disponibles.</p>
                                            <%
                                                    }
                                                } catch (Exception e) {
                                                    out.println("Error al conectar a la base de datos: " + e.getMessage());
                                                } finally {
                                                    // Cerrar la conexión utilizando el método de la clase Mantenimiento
                                                    try {
                                                        if (rs1 != null) rs1.close();
                                                        if (pstmt1 != null) pstmt1.close();
                                                        if (conexion != null) conexion.close();
                                                    } catch (SQLException e) {
                                                        out.println("Error al cerrar la conexión: " + e.getMessage());
                                                    }
                                                }
                                            %>
                                        </div>
                                        <button id="prev" class="absolute left-0 top-1/2 transform -translate-y-1/2 bg-gray-700 text-white p-2 rounded-full z-10">
                                            &#10094;
                                        </button>
                                        <button id="next" class="absolute right-0 top-1/2 transform -translate-y-1/2 bg-gray-700 text-white p-2 rounded-full z-10">
                                            &#10095;
                                        </button>
                                    </div>
                                    <h1 class="text-2xl font-bold text-gray-800  text-center mt-8">Usado por las marcas de relojes más utilizadas del Perú</h1>
                                    <div class="bg-yellow-500 h-1 w-48 mx-auto mt-2 rounded-full border border-yellow-500"></div>

                                    <div class="container mx-auto px-4 py-8 ">
                                        <div class="grid grid-cols-1 md:grid-cols-3 gap-8">

                                            <div class="bg-white shadow-lg rounded-lg overflow-hidden p-6 justify-center mt-14">
                                                <img src="https://1000marcas.net/wp-content/uploads/2020/01/Casio-simbolo.jpg" alt="marca1" class="w-48 h-auto mx-auto" />

                                            </div>

                                            <div class="bg-white shadow-lg rounded-lg overflow-hidden p-6 justify-center mt-14">
                                                <img src="https://upload.wikimedia.org/wikipedia/commons/3/34/Festina_1902_ENG.png" alt="marca2" class="w-48 h-auto mx-auto" />

                                            </div>
                                            <div class="bg-white shadow-lg rounded-lg overflow-hidden p-6 justify-center mt-14">
                                                <img src="https://i.pinimg.com/originals/ea/48/06/ea4806949f5b24f73ab70ce55ca8e820.png" alt="marca2" class="w-48 h-auto mx-auto" />

                                            </div>
                                            <div class="bg-white shadow-lg rounded-lg overflow-hidden p-6 justify-center mt-14">
                                                <img src="https://1000marcas.net/wp-content/uploads/2021/05/Fossil-Logo.png" alt="marca2" class="w-48 h-auto mx-auto" />

                                            </div>
                                            <div class="bg-white shadow-lg rounded-lg overflow-hidden p-6 justify-center mt-14">
                                                <img src="https://seeklogo.com/images/T/tommy-hilfiger-logo-3C7109A491-seeklogo.com.png" alt="marca2" class="w-48 h-auto mx-auto" />

                                            </div>
                                            <div class="bg-white shadow-lg rounded-lg overflow-hidden p-6 justify-center mt-14">
                                                <img src="https://i.pinimg.com/736x/9c/d1/f8/9cd1f851f1571d42f8b1531b585b08d1.jpg" alt="marca2" class="w-48 h-auto mx-auto" />

                                            </div>
                                        </div>
                                    </div>

                                    <div id="modalContainer" class="fixed inset-0 z-50 hidden overflow-y-auto " aria-labelledby="modal-title"
                                         role="dialog" aria-modal="true">
                                        <div class="flex items-center justify-center min-h-screen px-4 pt-4 pb-20 text-center sm:block sm:p-0">
                                            <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity" aria-hidden="true"></div>
                                            <span class="hidden sm:inline-block sm:align-middle sm:h-screen" aria-hidden="true">&#8203;</span>
                                            <!-- Agrega la clase "relative" al contenedor del formulario -->
                                            <div
                                                class="bg-white p-8 rounded-lg shadow-lg w-full max-w-md relative inline-block align-bottom bg-white rounded-lg text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-lg sm:w-full animate__animated animate__fadeInDown">
                                                <!-- Agrega un botón "X" para cerrar el modal -->
                                                <button id="closeModalButton"
                                                        class="absolute top-0 right-0 mt-4 mr-4 text-gray-500 hover:text-gray-700 focus:outline-none focus:ring-2 focus:ring-indigo-500">
                                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24"
                                                         stroke="currentColor">
                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                              d="M6 18L18 6M6 6l12 12" />
                                                    </svg>
                                                </button>
                                                <div class="text-center">
                                                    <h2 class="text-3xl font-extrabold text-gray-900">Iniciar Sesion</h2>
                                                </div>
                                                <form class="mt-8 space-y-6" action="procesarlogin.jsp" method="POST">
                                                    <!-- Agrega un contenedor para el enlace "Crear una cuenta" -->

                                                    <div>
                                                        <label for="email-address" class="block text-sm font-medium text-gray-700">Usuario</label>
                                                        <input id="email-address" name="usuario" type="text" required
                                                               class="mt-1 appearance-none rounded-md relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm"
                                                               placeholder="Ingrese el usuario">
                                                    </div>
                                                    <div>
                                                        <label for="password" class="block text-sm font-medium text-gray-700">Contraseña</label>
                                                        <input id="password" name="password" type="password" required
                                                               class="mt-1 appearance-none rounded-md relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm"
                                                               placeholder="Ingresa su contraseña">
                                                    </div>

                                                    <div>
                                                        <button type="submit"
                                                                class="w-full flex justify-center py-2 px-4 text-white bg-black text-xl font-semibold border px-4 py-2 rounded-lg hover:text-white hover:border-yellow-600 hover:bg-yellow-600 mb-4 md:mb-0">Ingresar</button>
                                                    </div>
                                                    <div class="mb-4 text-center">
                                                        <a href="#" class="text-sm text-yellow-700 hover:underline" id="createAccountLink">¿No tienes
                                                            una cuenta? Crear una</a>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                    </div>

                                    <div id="registroModalContainer" class="fixed inset-0 z-50 hidden overflow-y-auto "
                                         aria-labelledby="registro-modal-title" role="dialog" aria-modal="true">
                                        <div class="flex items-center justify-center min-h-screen px-4 pt-4 pb-20 text-center sm:block sm:p-0">
                                            <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity" aria-hidden="true"></div>
                                            <span class="hidden sm:inline-block sm:align-middle sm:h-screen" aria-hidden="true">&#8203;</span>
                                            <div
                                                class="bg-white p-8 rounded-lg shadow-lg w-full max-w-md relative inline-block align-bottom bg-white rounded-lg text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-lg sm:w-full animate__animated animate__fadeInDown">
                                                <button id="closeRegistroModalButton"
                                                        class="absolute top-0 right-0 mt-4 mr-4 text-gray-500 hover:text-gray-700 focus:outline-none focus:ring-2 focus:ring-indigo-500">
                                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24"
                                                         stroke="currentColor">
                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                              d="M6 18L18 6M6 6l12 12" />
                                                    </svg>
                                                </button>
                                                <div class="text-center">
                                                    <h2 id="registro-modal-title" class="text-3xl font-extrabold text-gray-900">Crear Cuenta</h2>
                                                </div>
                                                <form id="registroForm" class="mt-8 space-y-6" action="procesoregistrousuario.jsp" method="POST">
                                                    <div>
                                                        <label for="nombreUsuario" class="block text-sm font-medium text-gray-700">Nombre de usuario</label>
                                                        <input id="nombreUsuario" name="nombreUsuario" type="text" required
                                                               class="mt-1 appearance-none rounded-md relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm"
                                                               placeholder="Ingrese el nombre de usuario">
                                                            <span id="errorNombreUsuario" class="text-red-500 text-sm hidden">El nombre de usuario debe ser una sola palabra.</span>
                                                    </div>
                                                    <div>
                                                        <label for="correo" class="block text-sm font-medium text-gray-700">Correo electrónico</label>
                                                        <input id="correo" name="correo" type="email" required
                                                               class="mt-1 appearance-none rounded-md relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm"
                                                               placeholder="Ingrese su correo electrónico">
                                                    </div>
                                                    <div>
                                                        <label for="password" class="block text-sm font-medium text-gray-700">Contraseña</label>
                                                        <input id="password" name="password" type="password" required
                                                               class="mt-1 appearance-none rounded-md relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm"
                                                               placeholder="Ingrese su contraseña">
                                                    </div>
                                                    <div class="grid grid-cols-2 gap-4">
                                                        <div>
                                                            <label for="nombre" class="block text-sm font-medium text-gray-700">Nombre</label>
                                                            <input id="nombre" name="nombre" type="text" required
                                                                   class="mt-1 appearance-none rounded-md relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm"
                                                                   placeholder="Ingrese su nombre">
                                                        </div>
                                                        <div>
                                                            <label for="apellido" class="block text-sm font-medium text-gray-700">Apellido</label>
                                                            <input id="apellido" name="apellido" type="text" required
                                                                   class="mt-1 appearance-none rounded-md relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm"
                                                                   placeholder="Ingrese su apellido">
                                                        </div>
                                                    </div>
                                                    <div class="grid grid-cols-2 gap-4">
                                                        <div>
                                                            <label for="tipo_documento" class="block text-sm font-medium text-gray-700">Tipo Documento</label>
                                                            <select id="tipo_documento" name="tipo_documento" required
                                                                    class="mt-1 appearance-none rounded-md relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm">
                                                                <option value="1">DNI</option>
                                                                <option value="2">Pasaporte</option>
                                                            </select>
                                                        </div>
                                                        <div>
                                                            <label for="numeroDocumento" class="block text-sm font-medium text-gray-700">Número Documento</label>
                                                            <input id="numeroDocumento" name="numeroDocumento" type="text" pattern="^[0-9]{8}$" maxlength="8"  required
                                                                   class="mt-1 appearance-none rounded-md relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm"
                                                                   placeholder="Ingrese su número de documento">
                                                        </div>
                                                    </div>
                                                    <div>
                                                        <label for="telefono" class="block text-sm font-medium text-gray-700">Teléfono</label>
                                                        <input id="telefono" name="telefono" type="tel" required pattern="^[0-9]{9}$" maxlength="9"
                                                               class="mt-1 appearance-none rounded-md relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm"
                                                               placeholder="Ingrese su teléfono">
                                                    </div>
                                                    <div>
                                                        <button type="submit"
                                                                class="w-full flex justify-center py-2 px-4 text-white bg-black text-xl font-semibold border px-4 py-2 rounded-lg hover:text-white hover:border-yellow-600 hover:bg-yellow-600 mb-4 md:mb-0">Crear
                                                            Cuenta</button>
                                                    </div>
                                                </form>

                                            </div>
                                        </div>
                                    </div>
                                    <%
                            // Obtener el parámetro "succes" de la URL
                            String succesParam = request.getParameter("succes");

                            // Verificar si el parámetro es igual a "true"
                            if (succesParam != null && succesParam.equals("true")) {
                                // Hacer algo si es true
                                // Por ejemplo, mostrar un mensaje de éxito
                                    %>
                                    <div id="alerta" class="fixed top-24 right-4 transform z-50 flex items-center w-full max-w-xs p-4 mb-4 text-gray-500 bg-gray-100 rounded-lg shadow dark:text-gray-400 dark:bg-gray-800 animate__animated animate__bounceInRight" role="alert">
                                        <div class="inline-flex items-center justify-center flex-shrink-0 w-8 h-8 text-green-500 bg-green-100 rounded-lg dark:bg-green-700 dark:text-green-200">
                                            <svg class="w-5 h-5" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="currentColor"
                                                 viewBox="0 0 20 20">
                                                <path
                                                    d="M10 .5a9.5 9.5 0 1 0 9.5 9.5A9.51 9.51 0 0 0 10 .5Zm3.707 8.207-4 4a1 1 0 0 1-1.414 0l-2-2a1 1 0 0 1 1.414-1.414L9 10.586l3.293-3.293a1 1 0 0 1 1.414 1.414Z" />
                                            </svg>
                                            <span class="sr-only">Check icon</span>
                                        </div>
                                        <div class="ml-3 text-sm font-normal">Sesion iniciada correctamente</div>
                                        <button type="button" onclick="cerrarAlerta()" class="ml-auto -mx-1.5 -my-1.5 bg-slate-50 text-gray-400 hover:text-gray-900 rounded-lg focus:ring-2 focus:ring-gray-300 p-1.5 hover:bg-white inline-flex items-center justify-center h-8 w-8 dark:text-gray-500 dark:hover:text-white dark:bg-gray-800 dark:hover:bg-gray-700" aria-label="Close">
                                            <span class="sr-only">Close</span>
                                            <svg class="w-3 h-3" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 14 14">
                                                <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m1 1 6 6m0 0 6 6M7 7l6-6M7 7l-6 6"/>
                                            </svg>
                                        </button>
                                    </div>
                                    <%
                                } 
                                    %>
                                    <%
                             // Obtener el parámetro "error" de la URL
                             String errorParam = request.getParameter("error");

                             // Verificar si el parámetro es igual a "true"
                             if (errorParam != null && errorParam.equals("true")) {
                                 // Hacer algo si es true
                                 // Por ejemplo, mostrar un mensaje de error
                                    %>
                                    <div id="alerta" class="fixed top-24 right-4 transform z-50 flex items-center w-full max-w-xs p-4 mb-4 text-gray-500 bg-slate-50 rounded-lg shadow dark:text-gray-400 dark:bg-gray-800 animate__animated animate__bounceInRight" role="alert">
                                        <div class="inline-flex items-center justify-center flex-shrink-0 w-8 h-8 text-red-500 bg-red-100 rounded-lg dark:bg-red-700 dark:text-red-200">
                                            <svg class="w-5 h-5" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="currentColor"
                                                 viewBox="0 0 20 20">
                                                <path
                                                    d="M10 .5a9.5 9.5 0 1 0 9.5 9.5A9.51 9.51 0 0 0 10 .5Zm3.707 11.793a1 1 0 1 1-1.414 1.414L10 11.414l-2.293 2.293a1 1 0 0 1-1.414-1.414L8.586 10 6.293 7.707a1 1 0 0 1 1.414-1.414L10 8.586l2.293-2.293a1 1 0 0 1 1.414 1.414L11.414 10l2.293 2.293Z" />
                                            </svg>
                                            <span class="sr-only">Warning icon</span>
                                        </div>
                                        <div class="ml-3 text-sm font-normal">Usuario y contraseñas incorrectas</div>
                                        <button type="button" onclick="cerrarAlerta()" class="ml-auto -mx-1.5 -my-1.5 bg-gray-100 text-gray-400 hover:text-gray-900 rounded-lg focus:ring-2 focus:ring-gray-300 p-1.5 hover:bg-white inline-flex items-center justify-center h-8 w-8 dark:text-gray-500 dark:hover:text-white dark:bg-gray-800 dark:hover:bg-gray-700" aria-label="Close">
                                            <span class="sr-only">Close</span>
                                            <svg class="w-3 h-3" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 14 14">
                                                <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m1 1 6 6m0 0 6 6M7 7l6-6M7 7l-6 6"/>
                                            </svg>
                                        </button>
                                    </div>
                                    <%
                                    }
                                    %>

                                    <%
                                    // Verificar si el parámetro "success" está presente en la URL y es "true"
                                    String success = request.getParameter("success");
                                    if (success != null && success.equals("true")) {
                                    %>
                                    <div id="alerta" class="fixed top-24 right-4 transform z-50 flex items-center w-full max-w-xs p-4 mb-4 text-gray-500 bg-gray-100 rounded-lg shadow dark:text-gray-400 dark:bg-gray-800 animate__animated animate__bounceInRight" role="alert">
                                        <div class="inline-flex items-center justify-center flex-shrink-0 w-8 h-8 text-green-500 bg-green-100 rounded-lg dark:bg-green-700 dark:text-green-200">
                                            <svg class="w-5 h-5" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="currentColor"
                                                 viewBox="0 0 20 20">
                                                <path
                                                    d="M10 .5a9.5 9.5 0 1 0 9.5 9.5A9.51 9.51 0 0 0 10 .5Zm3.707 8.207-4 4a1 1 0 0 1-1.414 0l-2-2a1 1 0 0 1 1.414-1.414L9 10.586l3.293-3.293a1 1 0 0 1 1.414 1.414Z" />
                                            </svg>
                                            <span class="sr-only">Check icon</span>
                                        </div>
                                        <div class="ml-3 text-sm font-normal">Se ha registrado correctamente</div>
                                        <button type="button" onclick="cerrarAlerta()" class="ml-auto -mx-1.5 -my-1.5 bg-slate-50 text-gray-400 hover:text-gray-900 rounded-lg focus:ring-2 focus:ring-gray-300 p-1.5 hover:bg-white inline-flex items-center justify-center h-8 w-8 dark:text-gray-500 dark:hover:text-white dark:bg-gray-800 dark:hover:bg-gray-700" aria-label="Close">
                                            <span class="sr-only">Close</span>
                                            <svg class="w-3 h-3" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 14 14">
                                                <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m1 1 6 6m0 0 6 6M7 7l6-6M7 7l-6 6"/>
                                            </svg>
                                        </button>
                                    </div>
                                    <%
                                    }
                                    %>
                                    <% 
                                    String error = request.getParameter("error");
                                    %>

                                    <% if (error != null && error.equals("nombre_usuario_existe")) { %>
                                    <div id="alerta" class="fixed top-24 right-4 transform z-50 flex items-center w-full max-w-xs p-4 mb-4 text-gray-500 bg-gray-100 rounded-lg shadow dark:text-gray-400 dark:bg-gray-800 animate__animated animate__bounceInRight" role="alert">
                                        <div class="inline-flex items-center justify-center flex-shrink-0 w-8 h-8 text-red-500 bg-red-100 rounded-lg dark:bg-red-700 dark:text-red-200">
                                            <svg class="w-5 h-5" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="currentColor"
                                                 viewBox="0 0 20 20">
                                                <path
                                                    d="M10 .5a9.5 9.5 0 1 0 9.5 9.5A9.51 9.51 0 0 0 10 .5Zm3.707 11.793a1 1 0 1 1-1.414 1.414L10 11.414l-2.293 2.293a1 1 0 0 1-1.414-1.414L8.586 10 6.293 7.707a1 1 0 0 1 1.414-1.414L10 8.586l2.293-2.293a1 1 0 0 1 1.414 1.414L11.414 10l2.293 2.293Z" />
                                            </svg>
                                            <span class="sr-only">Warning icon</span>
                                        </div>
                                        <div class="ml-3 text-sm font-normal">El nombre de usuario ya existe.</div>
                                        <button type="button" onclick="cerrarAlerta()" class="ml-auto -mx-1.5 -my-1.5 bg-slate-50 text-gray-400 hover:text-gray-900 rounded-lg focus:ring-2 focus:ring-gray-300 p-1.5 hover:bg-white inline-flex items-center justify-center h-8 w-8 dark:text-gray-500 dark:hover:text-white dark:bg-gray-800 dark:hover:bg-gray-700" aria-label="Close">
                                            <span class="sr-only">Close</span>
                                            <svg class="w-3 h-3" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 14 14">
                                                <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m1 1 6 6m0 0 6 6M7 7l6-6M7 7l-6 6"/>
                                            </svg>
                                        </button>
                                    </div>
                                    <% } 
                                    %>

                                    <footer class="bg-gray-100 text-black py-8">
                                        <div class="bg-gray-100">
                                            <div class="max-w-screen-lg px-4 sm:px-6 text-gray-800 sm:grid md:grid-cols-4 sm:grid-cols-2 mx-auto">
                                                <div class="p-5">
                                                    <img src="img/ace.png" alt="Logo de ACE Time" class="w-36 h-auto" />
                                                </div>
                                                <div class="p-5">
                                                    <div class="text-sm uppercase text-yellow-600 font-bold">Recursos</div>
                                                    <a class="my-3 block" href="#">Documentación</a>
                                                    <a class="my-3 block" href="#">Tutoriales</a>
                                                    <a class="my-3 block" href="#">Soporte</a>
                                                </div>
                                                <div class="p-5">
                                                    <div class="text-sm uppercase text-yellow-600 font-bold">Soporte</div>
                                                    <a class="my-3 block" href="#">Centro de Ayuda</a>
                                                    <a class="my-3 block" href="#">Política de Privacidad</a>
                                                    <a class="my-3 block" href="#">Condiciones</a>
                                                    <a class="my-3 block" href="#">Política de Devolución</a> <!-- Modificación: Política de Devolución -->
                                                </div>
                                                <div class="p-5">
                                                    <div class="text-sm uppercase text-yellow-600 font-bold">Contáctanos</div>
                                                    <a class="my-3 block" href="#">XXX XXXX, Piso 4, SJL, Lima
                                                        <span class="text-teal-600 text-xs p-1"></span>
                                                    </a>
                                                    <a class="my-3 block" href="#">contacto@empresa.com
                                                        <span class="text-teal-600 text-xs p-1"></span>
                                                    </a>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="bg-gray-100 pt-2">
                                            <div class="flex pb-5 px-3 m-auto pt-5 border-t text-gray-800 text-sm flex-col max-w-screen-lg items-center">
                                                <div class="md:flex-auto md:flex-row-reverse mt-2 flex-row flex gap-5">
                                                    <a href="#" class="text-black hover:text-yellow-500"><i class="fab fa-facebook"></i></a>
                                                    <a href="#" class="text-black hover:text-yellow-500"><i class="fab fa-twitter"></i></a>
                                                    <a href="#" class="text-black hover:text-yellow-500"><i class="fab fa-instagram"></i></a>
                                                    <a href="#" class="text-black hover:text-yellow-500"><i class="fab fa-linkedin"></i></a>
                                                </div>
                                                <div class="my-5">© Derechos de autor 2024. Todos los derechos reservados.</div>
                                            </div>
                                        </div>
                                    </footer>
                                    <script src="js/navbar.js"></script>
                                    <script src="js/ModalSesion.js"></script>
                                    <script>
                                            function cerrarAlerta() {
                                                var alerta = document.getElementById('alerta');
                                                alerta.style.display = 'none';
                                            }
                                    </script>
                                    <script src="js/ValidacionSesion.js"></script>
                                    <script src="js/slider.js"></script>
                                </body>

                                </html>