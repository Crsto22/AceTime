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
<html lang="es">
    <head>
        <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Configuracion</title>
                <link href="https://cdn.jsdelivr.net/npm/daisyui@4.12.2/dist/full.min.css" rel="stylesheet" type="text/css" />
                <script src="https://cdn.tailwindcss.com"></script>
                <link rel='stylesheet' href='https://cdn-uicons.flaticon.com/2.4.0/uicons-regular-rounded/css/uicons-regular-rounded.css'>
                    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css" />

                    </head>
                    <body>
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
                                    if (rs != null) {
                                        rs.close();
                                    }
                                    if (stmt != null) {
                                        stmt.close();
                                    }
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
                                                    <a href="index.jsp" class="flex items-center py-0 px-0 text-gray-700 hover:text-gray-900">
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
                                                                <span class="badge badge-xl indicator-item bg-yellow-400 text-white"><%= totalProductos%></span>
                                                            </div>
                                                        </div>
                                                        <div tabindex="0" class="mt-3 z-50 card card-compact dropdown-content w-52 bg-base-100 shadow">
                                                            <div class="card-body">
                                                                <span class="font-bold text-lg"><%= totalProductos%> Productos</span>
                                                                <span class="text-yellow-600">Subtotal: S/ <%= CostoTotal%></span>
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
                                                                <span class="text-gray-500">Hola, <span class="font-bold"><%= session.getAttribute("nombreUsuario")%></span></span>
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
                                                                <span class="text-gray-500">Hola, <span class="font-bold"><%= session.getAttribute("nombreUsuario")%></span></span>
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
                                                <div class="sm:hidden cursor-pointer" >
                                                    <div tabindex="0" role="button" class="btn btn-ghost btn-circle " onclick="window.location.href = 'carito.jsp';">
                                                        <div class="indicator">
                                                            <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z" />
                                                            </svg>
                                                            <span class="badge badge-xl indicator-item bg-yellow-400 text-white"><%= totalProductos%></span>
                                                        </div>
                                                    </div>
                                                    <i id="mobileMenuButton" class="fi fi-rr-menu-burger text-4xl mx-6"></i>
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
                                                    <a onclick="my_modal_3.showModal()" class="text-gray-800 text-base font-semibold hover:text-yellow-600 mb-1 mx-5"> <i class="fi fi-rr-sign-in-alt"></i> Iniciar Sesion</a>
                                                    <%
                                                        }
                                                    %>
                                                    <!-- Botón para productos -->
                                                    <div tabindex="0" role="button" class="btn btn-ghost btn-circle mx-5" onclick="window.location.href = 'carito.jsp';">
                                                        <div class="indicator">
                                                            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z" />
                                                            </svg>
                                                            <span class="badge badge-xl indicator-item bg-yellow-400 text-white"><%= totalProductos%></span>
                                                        </div>
                                                    </div>

                                                    <!-- Primer modal -->
                                                    <dialog id="my_modal_3" class="modal">
                                                        <div class="modal-box">
                                                            <form method="dialog">
                                                                <button class="btn btn-sm btn-circle btn-ghost absolute right-2 top-2">
                                                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                                                                    </svg>
                                                                </button>
                                                            </form>
                                                            <div class="text-center">
                                                                <h2 class="text-3xl font-extrabold text-gray-900">Iniciar Sesion</h2>
                                                            </div>
                                                            <form class="mt-8 space-y-6" action="procesarlogin.jsp" method="POST">
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
                                                                            class="w-full flex justify-center py-2 px-4 text-white bg-black text-xl font-semibold border px-4 py-2 rounded-lg hover:text-white hover:border-yellow-600 hover:bg-yellow-600 mb-4 md:mb-0">
                                                                        Ingresar
                                                                    </button>
                                                                </div>
                                                                <div class="mb-4 text-center">
                                                                    <a href="#" onclick="document.getElementById('my_modal_2').showModal()" class="text-sm text-yellow-700 hover:underline">¿No tienes una cuenta? Crear una</a>
                                                                </div>
                                                            </form>
                                                        </div>
                                                    </dialog>

                                                    <!-- Segundo modal -->
                                                     <dialog id="my_modal_2" class="modal">
                                                                <div class="modal-box">
                                                                    <form method="dialog">
                                                                        <button class="btn btn-sm btn-circle btn-ghost absolute right-2 top-2">
                                                                            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                                                                            </svg>
                                                                        </button>
                                                                    </form>
                                                                    <div class="text-center">
                                                                        <h2 class="text-3xl font-extrabold text-gray-900">Crear Cuenta</h2>
                                                                    </div>
                                                                    <form class="registroForm mt-8 space-y-6" action="procesoregistrousuario.jsp" method="POST">
                                                                        <div>
                                                                            <label for="nombreUsuario1" class="block text-sm font-medium text-gray-700">Nombre de usuario</label>
                                                                            <input id="nombreUsuario1" name="nombreUsuario" type="text" required
                                                                                   class="nombreUsuario mt-1 appearance-none rounded-md relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm"
                                                                                   placeholder="Ingrese el nombre de usuario">
                                                                                <span class="errorNombreUsuario text-red-500 text-sm hidden">El nombre de usuario debe ser una sola palabra.</span>
                                                                        </div>
                                                                        <div>
                                                                            <label for="correo1" class="block text-sm font-medium text-gray-700">Correo electrónico</label>
                                                                            <input id="correo1" name="correo" type="email" required
                                                                                   class="mt-1 appearance-none rounded-md relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm"
                                                                                   placeholder="Ingrese su correo electrónico">
                                                                        </div>
                                                                        <div>
                                                                            <label for="password1" class="block text-sm font-medium text-gray-700">Contraseña</label>
                                                                            <input id="password1" name="password" type="password" required
                                                                                   class="mt-1 appearance-none rounded-md relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm"
                                                                                   placeholder="Ingrese su contraseña">
                                                                        </div>
                                                                        <div class="grid grid-cols-2 gap-4">
                                                                            <div>
                                                                                <label for="nombre1" class="block text-sm font-medium text-gray-700">Nombre</label>
                                                                                <input id="nombre1" name="nombre" type="text" required
                                                                                       class="mt-1 appearance-none rounded-md relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm"
                                                                                       placeholder="Ingrese su nombre">
                                                                            </div>
                                                                            <div>
                                                                                <label for="apellido1" class="block text-sm font-medium text-gray-700">Apellido</label>
                                                                                <input id="apellido1" name="apellido" type="text" required
                                                                                       class="mt-1 appearance-none rounded-md relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm"
                                                                                       placeholder="Ingrese su apellido">
                                                                            </div>
                                                                        </div>
                                                                        <div class="grid grid-cols-2 gap-4">
                                                                            <div>
                                                                                <label for="tipo_documento1" class="block text-sm font-medium text-gray-700">Tipo Documento</label>
                                                                                <select id="tipo_documento1" name="tipo_documento" required
                                                                                        class="mt-1 appearance-none rounded-md relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm">
                                                                                    <option value="1">DNI</option>
                                                                                    <option value="2">Pasaporte</option>
                                                                                </select>
                                                                            </div>
                                                                            <div>
                                                                                <label for="numeroDocumento1" class="block text-sm font-medium text-gray-700">Número Documento</label>
                                                                                <input id="numeroDocumento1" name="numeroDocumento" type="text" pattern="^[0-9]{8}$" maxlength="8" required
                                                                                       class="mt-1 appearance-none rounded-md relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm"
                                                                                       placeholder="Ingrese su número de documento">
                                                                            </div>
                                                                        </div>
                                                                        <div>
                                                                            <label for="telefono1" class="block text-sm font-medium text-gray-700">Teléfono</label>
                                                                            <input id="telefono1" name="telefono" type="tel" required pattern="^[0-9]{9}$" maxlength="9"
                                                                                   class="mt-1 appearance-none rounded-md relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm"
                                                                                   placeholder="Ingrese su teléfono">
                                                                        </div>
                                                                        <div>
                                                                            <button type="submit"
                                                                                    class="w-full flex justify-center py-2 px-4 text-white bg-black text-xl font-semibold border px-4 py-2 rounded-lg hover:text-white hover:border-yellow-600 hover:bg-yellow-600 mb-4 md:mb-0">
                                                                                Crear Cuenta
                                                                            </button>
                                                                        </div>
                                                                    </form>
                                                                </div>
                                                            </dialog>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </nav>
                            <div class="container mx-auto mt-28">
                                <div class="w-full">
                                    <div class="flex justify-center space-x-4">
                                        <button class="tablinks py-2 px-4 bg-gray-200 rounded hover:bg-red-500 hover:text-white focus:outline-none" onclick="openTab(event, 'MiPerfil')"><i class="fi fi-rr-user"></i> Mi perfil</button>
                                        <button class="tablinks py-2 px-4 bg-gray-200 rounded hover:bg-red-500 hover:text-white focus:outline-none" onclick="openTab(event, 'MisPedidos')"><i class="fi fi-rr-shopping-bag"></i> Mis pedidos</button>
                                        <button class="tablinks py-2 px-4 bg-gray-200 rounded hover:bg-red-500 hover:text-white focus:outline-none" onclick="openModal()"> <i class="fi fi-rr-exit"></i> Salir</button>
                                    </div>

                                    <div id="MiPerfil" class="tabcontent p-4">
                                        <div class="max-w-5xl mx-auto bg-white rounded-lg overflow-hidden shadow-lg">
                                            <div class="p-4 my-10 xl:mx-8">
                                                <h3 class="text-2xl mb-4 font-bold">Mi perfil </h3>
                                                <%
                                                    String rol = (String) session.getAttribute("rol");

                                                    // Verificar si el rol es "admin"
                                                    if (!"admin".equals(rol)) {
                                                %>
                                                <button
                                                    id="openActualizarModalButton"
                                                    class="align-middle select-none font-sans font-bold text-center uppercase transition-all text-xs py-3 px-6 rounded-lg bg-gray-900 text-white shadow-md shadow-gray-900/10 hover:shadow-lg hover:shadow-gray-900/20 focus:opacity-[0.85] focus:shadow-none active:opacity-[0.85] active:shadow-none"
                                                    type="button"
                                                    >
                                                    Actualizar Datos
                                                </button>
                                                <%
                                                } else {
                                                %>
                                                <button
                                                    id="openActualizarModalButton"
                                                    class="align-middle select-none font-sans font-bold text-center uppercase transition-all disabled:opacity-50 disabled:shadow-none disabled:pointer-events-none text-xs py-3 px-6 rounded-lg bg-gray-900 text-white shadow-md shadow-gray-900/10 hover:shadow-lg hover:shadow-gray-900/20 focus:opacity-[0.85] focus:shadow-none active:opacity-[0.85] active:shadow-none"
                                                    type="button"
                                                    disabled
                                                    >
                                                    Actualizar Datos
                                                </button>
                                                <%
                                                    }
                                                %>
                                                <div class="space-y-2">
                                                    <%
                                                        Mantenimiento mantenimiento2 = new Mantenimiento();
                                                        mantenimiento2.conectarBD();
                                                        Connection conexion2 = mantenimiento2.getConexion();

                                                        if (idUsuario != null) {
                                                            try {
                                                                String sql = "SELECT * FROM Usuarios WHERE id_usuario = ?";
                                                                PreparedStatement declaracion = conexion2.prepareStatement(sql);
                                                                declaracion.setInt(1, idUsuario);

                                                                ResultSet resultado = declaracion.executeQuery();
                                                                if (resultado.next()) {
                                                                    session.setAttribute("nombre_usuario", resultado.getString("nombre_usuario"));
                                                                    session.setAttribute("correo", resultado.getString("correo"));
                                                                    session.setAttribute("nombre", resultado.getString("nombre"));
                                                                    session.setAttribute("contrasena", resultado.getString("contrasena"));
                                                                    session.setAttribute("apellidos", resultado.getString("apellido"));
                                                                    session.setAttribute("telefono", resultado.getString("telefono_movil"));
                                                                    session.setAttribute("Num_Documento", resultado.getString("Num_Documento"));
                                                                }
                                                                resultado.close();
                                                                declaracion.close();
                                                            } catch (SQLException e) {
                                                                e.printStackTrace();
                                                            }
                                                        }

                                                        mantenimiento2.cerrarBD();
                                                    %>
                                                    <div class="p-4 rounded-lg" id="userData"
                                                         data-nombre-usuario="<%= session.getAttribute("nombre_usuario")%>"
                                                         data-correo="<%= session.getAttribute("correo")%>"
                                                         data-nombre="<%= session.getAttribute("nombre")%>"
                                                         data-apellidos="<%= session.getAttribute("apellidos")%>"
                                                         data-telefono="<%= session.getAttribute("telefono")%>"
                                                         data-num-documento="<%= session.getAttribute("Num_Documento")%>"
                                                         data-contrasena="<%= session.getAttribute("contrasena")%>">
                                                        <h4 class="text-lg font-medium">Nombre de usuario: <span class="text-gray-600"><%= session.getAttribute("nombre_usuario")%></span></h4>
                                                        <h4 class="text-lg font-medium">Correo electrónico: <span class="text-gray-600"><%= session.getAttribute("correo")%></span></h4>
                                                        <h4 class="text-lg font-medium">Nombre: <span class="text-gray-600"><%= session.getAttribute("nombre")%></span></h4>
                                                        <h4 class="text-lg font-medium">Apellidos: <span class="text-gray-600"><%= session.getAttribute("apellidos")%></span></h4>
                                                        <h4 class="text-lg font-medium">Teléfono: <span class="text-gray-600"><%= session.getAttribute("telefono")%></span></h4>
                                                        <h4 class="text-lg font-medium">Numero Documento: <span class="text-gray-600"><%= session.getAttribute("Num_Documento")%></span></h4>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div id="MisPedidos" class="tabcontent p-4">
                                        <div class="max-w-5xl mx-auto bg-white rounded-lg overflow-hidden shadow-lg">
                                            <div class="p-4 my-10 xl:mx-8">
                                                <h3 class="text-xl font-semibold mb-4">Mis pedidos</h3>
                                                <table class="min-w-full bg-white  rounded-lg overflow-hidden shadow-lg">
                                                    <thead class="bg-red-600 text-white uppercase">
                                                        <tr>
                                                            <th class="px-6 py-3 border-b border-gray-200">ID Compra</th>
                                                            <th class="px-6 py-3 border-b border-gray-200">Fecha Pedido</th>
                                                            <th class="px-6 py-3 border-b border-gray-200">Total</th>
                                                            <th class="px-6 py-3 border-b border-gray-200">Comprobante</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody class="text-gray-700">
                                                        <%
                                                            Mantenimiento mantenimiento3 = new Mantenimiento();
                                                            mantenimiento3.conectarBD();
                                                            Connection conexion3 = mantenimiento3.getConexion();

                                                            // Supongamos que idUsuario es un parámetro que se pasa desde una solicitud HTTP
                                                            if (idUsuario != null) {
                                                                try {
                                                                    PreparedStatement stmt1 = conexion3.prepareStatement("SELECT * FROM Detalle_Compra WHERE id_usuario = ?");
                                                                    stmt1.setInt(1, idUsuario);
                                                                    ResultSet rs1 = stmt1.executeQuery();

                                                                    while (rs1.next()) { // Usar rs1 en lugar de rs
                                                                        int id_compra = rs1.getInt("id_compra");
                                                                        String fecha_compra = rs1.getString("fecha_compra");
                                                                        double total_compra = rs1.getDouble("total_compra");
                                                                        String id_usuario = rs1.getString("id_usuario");
                                                        %>                                    
                                                        <tr>
                                                            <td class="px-6 py-4 whitespace-nowrap border-b border-gray-200 text-center"><%= id_compra%></td>
                                                            <td class="px-6 py-4 whitespace-nowrap border-b border-gray-200 text-center"><%= fecha_compra%></td>
                                                            <td class="px-6 py-4 whitespace-nowrap border-b border-gray-200 text-center"><%= total_compra%></td>
                                                            <td class="px-6 py-4 whitespace-nowrap border-b border-gray-200 text-center">
                                                                <a href="javascript:void(0)" onclick="window.open('factura.jsp?id_compra=<%=id_compra%>&id_usuario=<%=id_usuario%>&fecha_comprobante=<%=fecha_compra%>', '_blank', 'width=700,height=900')" class="btn btn-warning text-white text-2xl">
                                                                    <i class="fi fi-rr-eye"></i>
                                                                </a>
                                                            </td>
                                                        </tr> 
                                                        <%
                                                                    }

                                                                    rs1.close();
                                                                    stmt1.close();
                                                                } catch (SQLException e) {
                                                                    e.printStackTrace();
                                                                }
                                                            }

                                                            mantenimiento3.cerrarBD();
                                                        %>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </div>

                                    <div id="Salir" class="tabcontent p-4 hidden">
                                    </div>
                                </div>
                            </div>

                            <div id="modal" class="hidden fixed inset-0 bg-gray-500 bg-opacity-75 flex items-center justify-center z-50 backdrop-blur-sm">
                                <div class="border rounded-lg shadow relative max-w-sm bg-white">
                                    <div class="flex justify-end p-2">
                                        <button id="closeModalBtn" type="button" class="text-gray-400 bg-transparent hover:bg-gray-200 hover:text-gray-900 rounded-lg text-sm p-1.5 ml-auto inline-flex items-center">
                                            <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg">
                                                <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd"></path>
                                            </svg>
                                        </button>
                                    </div>

                                    <div class="p-6 pt-0 text-center">
                                        <svg class="w-20 h-20 text-red-600 mx-auto" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                                        </svg>
                                        <h3 class="text-xl font-normal text-gray-500 mt-5 mb-6">¿Estás seguro de que deseas cerrar sesión ahora?</h3>
                                        <form action="cerrarsesion.jsp" method="post">
                                            <input type="hidden" id="numeroHabitacion" name="numeroHabitacion" value="">
                                                <button type="submit" class="text-white bg-red-600 hover:bg-red-800 focus:ring-4 focus:ring-red-300 font-medium rounded-lg text-base inline-flex items-center px-3 py-2.5 text-center mr-2">
                                                    Sí, estoy seguro
                                                </button>
                                                <a id="cancelBtn" class="text-gray-900 bg-white hover:bg-gray-100 focus:ring-4 focus:ring-cyan-200 border border-gray-200 font-medium inline-flex items-center rounded-lg text-base px-3 py-2.5 text-center cursor-pointer">
                                                    No, cancelar
                                                </a>
                                        </form>
                                    </div>
                                </div>
                            </div>  
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
                                    <div class="flex pb-5 px-3 m-auto pt-5 border-t text-gray-800 text-sm flex-col
                                         max-w-screen-lg items-center">
                                        <div class="md:flex-auto md:flex-row-reverse mt-2 flex-row flex gap-5">
                                            <a href="#" class="text-black hover:text-yellow-500"><i class="fab fa-facebook"></i></a>
                                            <a href="#" class="text-black hover:text-yellow-500"><i class="fab fa-twitter"></i></a>
                                            <a href="#" class="text-black hover:text-yellow-500"><i class="fab fa-instagram"></i></a>
                                            <a href="#" class="text-black hover:text-yellow-500"><i class="fab fa-linkedin"></i></a>
                                        </div>
                                        <div class="my-5">© Copyright 2024. All Rights Reserved.</div>
                                    </div>
                                </div>
                            </footer> 
                             <div id="registroModalContainer" class="fixed inset-0 z-50 hidden overflow-y-auto"
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
                                                <form class="registroForm mt-8 space-y-6" action="procesoregistrousuario.jsp" method="POST">
                                                    <div>
                                                        <label for="nombreUsuario2" class="block text-sm font-medium text-gray-700">Nombre de usuario</label>
                                                        <input id="nombreUsuario2" name="nombreUsuario" type="text" required
                                                               class="nombreUsuario mt-1 appearance-none rounded-md relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm"
                                                               placeholder="Ingrese el nombre de usuario">
                                                            <span class="errorNombreUsuario text-red-500 text-sm hidden">El nombre de usuario debe ser una sola palabra.</span>
                                                    </div>
                                                    <div>
                                                        <label for="correo2" class="block text-sm font-medium text-gray-700">Correo electrónico</label>
                                                        <input id="correo2" name="correo" type="email" required
                                                               class="mt-1 appearance-none rounded-md relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm"
                                                               placeholder="Ingrese su correo electrónico">
                                                    </div>
                                                    <div>
                                                        <label for="password2" class="block text-sm font-medium text-gray-700">Contraseña</label>
                                                        <input id="password2" name="password" type="password" required
                                                               class="mt-1 appearance-none rounded-md relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm"
                                                               placeholder="Ingrese su contraseña">
                                                    </div>
                                                    <div class="grid grid-cols-2 gap-4">
                                                        <div>
                                                            <label for="nombre2" class="block text-sm font-medium text-gray-700">Nombre</label>
                                                            <input id="nombre2" name="nombre" type="text" required
                                                                   class="mt-1 appearance-none rounded-md relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm"
                                                                   placeholder="Ingrese su nombre">
                                                        </div>
                                                        <div>
                                                            <label for="apellido2" class="block text-sm font-medium text-gray-700">Apellido</label>
                                                            <input id="apellido2" name="apellido" type="text" required
                                                                   class="mt-1 appearance-none rounded-md relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm"
                                                                   placeholder="Ingrese su apellido">
                                                        </div>
                                                    </div>
                                                    <div class="grid grid-cols-2 gap-4">
                                                        <div>
                                                            <label for="tipo_documento2" class="block text-sm font-medium text-gray-700">Tipo Documento</label>
                                                            <select id="tipo_documento2" name="tipo_documento" required
                                                                    class="mt-1 appearance-none rounded-md relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm">
                                                                <option value="1">DNI</option>
                                                                <option value="2">Pasaporte</option>
                                                            </select>
                                                        </div>
                                                        <div>
                                                            <label for="numeroDocumento2" class="block text-sm font-medium text-gray-700">Número Documento</label>
                                                            <input id="numeroDocumento2" name="numeroDocumento" type="text" pattern="^[0-9]{8}$" maxlength="8" required
                                                                   class="mt-1 appearance-none rounded-md relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm"
                                                                   placeholder="Ingrese su número de documento">
                                                        </div>
                                                    </div>
                                                    <div>
                                                        <label for="telefono2" class="block text-sm font-medium text-gray-700">Teléfono</label>
                                                        <input id="telefono2" name="telefono" type="tel" required pattern="^[0-9]{9}$" maxlength="9"
                                                               class="mt-1 appearance-none rounded-md relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm"
                                                               placeholder="Ingrese su teléfono">
                                                    </div>
                                                    <div>
                                                        <button type="submit"
                                                                class="w-full flex justify-center py-2 px-4 text-white bg-black text-xl font-semibold border px-4 py-2 rounded-lg hover:text-white hover:border-yellow-600 hover:bg-yellow-600 mb-4 md:mb-0">
                                                            Crear Cuenta
                                                        </button>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                            <% if (request.getParameter("success") != null) { %>

                            <div id="alerta" class="fixed top-24 right-4 transform z-50 flex items-center w-full max-w-xs p-4 mb-4 text-gray-500 bg-gray-100 rounded-lg shadow dark:text-gray-400 dark:bg-gray-800 animate__animated animate__bounceInRight" role="alert">
                                <div class="inline-flex items-center justify-center flex-shrink-0 w-8 h-8 text-green-500 bg-green-100 rounded-lg dark:bg-green-700 dark:text-green-200">
                                    <svg class="w-5 h-5" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="currentColor"
                                         viewBox="0 0 20 20">
                                        <path
                                            d="M10 .5a9.5 9.5 0 1 0 9.5 9.5A9.51 9.51 0 0 0 10 .5Zm3.707 8.207-4 4a1 1 0 0 1-1.414 0l-2-2a1 1 0 0 1 1.414-1.414L9 10.586l3.293-3.293a1 1 0 0 1 1.414 1.414Z" />
                                    </svg>
                                    <span class="sr-only">Check icon</span>
                                </div>
                                <div class="ml-3 text-sm font-normal">Datos Actualizados Correctamente</div>
                                <button type="button" onclick="cerrarAlerta()" class="ml-auto -mx-1.5 -my-1.5 bg-slate-50 text-gray-400 hover:text-gray-900 rounded-lg focus:ring-2 focus:ring-gray-300 p-1.5 hover:bg-white inline-flex items-center justify-center h-8 w-8 dark:text-gray-500 dark:hover:text-white dark:bg-gray-800 dark:hover:bg-gray-700" aria-label="Close">
                                    <span class="sr-only">Close</span>
                                    <svg class="w-3 h-3" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 14 14">
                                        <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m1 1 6 6m0 0 6 6M7 7l6-6M7 7l-6 6"/>
                                    </svg>
                                </button>
                            </div>
                            <% } %>

                            <% if (request.getParameter("error") != null) { %>

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
                            <% }%>

                            <script>
                                // Obtener el elemento del modal
                                const modal = document.getElementById('modal');

                                // Función para cerrar el modal
                                function closeModal() {
                                    modal.classList.add('hidden'); // Ocultar el modal
                                }

                                // Agregar un evento de clic al botón de cierre del modal
                                document.getElementById('closeModalBtn').addEventListener('click', closeModal);

                                // Agregar un evento de clic al botón "No, cancelar"
                                document.getElementById('cancelBtn').addEventListener('click', closeModal);
                            </script>
                            <script>
                                // Función para abrir la pestaña y resaltar el botón
                                function openTab(evt, tabName) {
                                    var i, tabcontent, tablinks;

                                    // Ocultar todo el contenido de las pestañas
                                    tabcontent = document.getElementsByClassName("tabcontent");
                                    for (i = 0; i < tabcontent.length; i++) {
                                        tabcontent[i].classList.add("hidden");
                                    }

                                    // Quitar la clase "active" de todos los botones de pestañas
                                    tablinks = document.getElementsByClassName("tablinks");
                                    for (i = 0; i < tablinks.length; i++) {
                                        tablinks[i].classList.remove("active");
                                        tablinks[i].classList.remove("bg-red-500");
                                        tablinks[i].classList.remove("text-white");
                                        tablinks[i].classList.add("bg-gray-200");
                                    }

                                    // Mostrar el contenido de la pestaña actual y agregar la clase "active" al botón de pestaña
                                    document.getElementById(tabName).classList.remove("hidden");
                                    evt.currentTarget.classList.add("active");
                                    evt.currentTarget.classList.remove("bg-gray-200");
                                    evt.currentTarget.classList.add("bg-red-500");
                                    evt.currentTarget.classList.add("text-white");
                                }

                                // Mostrar la primera pestaña por defecto
                                document.addEventListener("DOMContentLoaded", function () {
                                    document.getElementsByClassName("tablinks")[0].click();
                                });

                                // Función para mostrar el modal al hacer clic en el botón "Salir"
                                document.addEventListener("DOMContentLoaded", function () {
                                    document.getElementById("openModal").addEventListener("click", function () {
                                        document.getElementById("modal").classList.remove("hidden");
                                    });

                                    // Función para cerrar el modal al hacer clic en el botón de cancelar o fuera del modal
                                    document.getElementById("closeModalBtn").addEventListener("click", function () {
                                        document.getElementById("modal").classList.add("hidden");
                                    });

                                    document.getElementById("cancelBtn").addEventListener("click", function () {
                                        document.getElementById("modal").classList.add("hidden");
                                    });

                                    document.addEventListener("click", function (event) {
                                        if (event.target === document.getElementById("modal")) {
                                            document.getElementById("modal").classList.add("hidden");
                                        }
                                    });
                                });
                            </script>
                            <script>
                                function openModal() {
                                    document.getElementById("modal").classList.remove("hidden");
                                }
                            </script>

                            <script>
                                document.getElementById('openActualizarModalButton').addEventListener('click', function () {
                                    const userData = document.getElementById('userData');

                                    document.getElementById('nombreUsuario').value = userData.dataset.nombreUsuario || '';
                                    document.getElementById('correo').value = userData.dataset.correo || '';
                                    document.getElementById('nombre').value = userData.dataset.nombre || '';
                                    document.getElementById('apellido').value = userData.dataset.apellidos || '';
                                    document.getElementById('telefono').value = userData.dataset.telefono || '';
                                    document.getElementById('numeroDocumento').value = userData.dataset.numDocumento || '';
                                    document.getElementById('contrasena').value = userData.dataset.contrasena || '';

                                    document.getElementById('ActualizarModalContainer').classList.remove('hidden');
                                });

                                document.getElementById('closeActualizarModalButton').addEventListener('click', function () {
                                    document.getElementById('ActualizarModalContainer').classList.add('hidden');
                                });
                            </script>
                            <script>
                                function cerrarAlerta() {
                                    var alerta = document.getElementById('alerta');
                                    alerta.style.display = 'none';
                                }
                            </script>
                            <script>
                                document.getElementById('registroForm').addEventListener('submit', function (event) {
                                    const nombreUsuario = document.getElementById('nombreUsuario').value;
                                    const errorNombreUsuario = document.getElementById('errorNombreUsuario');
                                    const regex = /^\S+$/; // Regular expression to check for a single word (no spaces)

                                    if (!regex.test(nombreUsuario)) {
                                        errorNombreUsuario.classList.remove('hidden');
                                        event.preventDefault(); // Prevent form submission
                                    } else {
                                        errorNombreUsuario.classList.add('hidden');
                                    }
                                });
                            </script>
                            <script src="js/navbar.js"></script>
                        </body>
                        </html>