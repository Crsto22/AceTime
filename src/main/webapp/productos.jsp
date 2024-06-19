<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
<%@ page import="datos.Marca" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Productos</title>
        <link href="https://cdn.jsdelivr.net/npm/daisyui@4.12.2/dist/full.min.css" rel="stylesheet" type="text/css" />
        <script src="https://cdn.tailwindcss.com"></script>
        <link rel="stylesheet" href="https://cdn-uicons.flaticon.com/2.3.0/uicons-regular-rounded/css/uicons-regular-rounded.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <script src="https://cdn.tailwindcss.com"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
        <link rel='stylesheet' href='https://cdn-uicons.flaticon.com/2.4.0/uicons-regular-rounded/css/uicons-regular-rounded.css'>
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

            Mantenimiento mantenimiento5 = new Mantenimiento();
            mantenimiento5.conectarBD();
            List<Marca> marcas = mantenimiento5.obtenerMarcas();
            mantenimiento5.cerrarBD();

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

        <div class="container mx-auto px-4 mt-28">
            <h1 class="text-4xl font-bold text-center mt-20">Productos</h1>
            <div class="bg-yellow-500 h-1 w-24 mx-auto rounded-full border border-yellow-500"></div>
        </div>
        <% String mensaje = request.getParameter("mensaje"); %>
        <% if (mensaje != null && !mensaje.isEmpty()) { %>
        <% if (mensaje.equals("insuficiente")) { %>
        <div id="alerta-insuficiente" class="fixed top-24 right-4 md:top-22 md:right-6 lg:top-24 lg:right-8 h-auto w-11/12 md:w-2/3 lg:w-1/2 max-w-sm mx-auto bg-white dark:bg-gray-900 shadow-lg rounded-lg overflow-hidden border-t-2 border-red-500 mt-8 animate__animated animate__fadeInDown z-10">
            <div class="px-6 py-4">
                <div class="flex items-center justify-between">
                    <div class="flex items-center">
                        <svg xmlns="http://www.w3.org/2000/svg" class="w-8 h-8 text-red-500 stroke-current" fill="none" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                        </svg>
                        <div class="ml-3">
                            <div class="font-bold text-left text-black dark:text-gray-50">¡Sin stock!</div>
                            <div class="w-full text-gray-900 dark:text-gray-300 mt-1">No hay stock disponible.</div>
                        </div>
                    </div>
                    <button onclick="document.getElementById('alerta-insuficiente').style.display = 'none'" class="text-gray-500 hover:text-gray-700 dark:text-gray-300 dark:hover:text-gray-500">
                        <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                        </svg>
                    </button>
                </div>
            </div>
        </div>
        <% } else if (mensaje.equals("agregado")) { %>
        <div id="alerta-agregado" class="fixed top-24 right-4 md:top-22 md:right-6 lg:top-24 lg:right-8 h-auto w-11/12 md:w-2/3 lg:w-1/2 max-w-sm mx-auto bg-white dark:bg-gray-900 shadow-lg rounded-lg overflow-hidden border-t-2 border-green-500 mt-8 animate__animated animate__fadeInDown z-20">
            <div class="px-6 py-4">
                <div class="flex items-center justify-between">
                    <div class="flex items-center">
                        <svg xmlns="http://www.w3.org/2000/svg" class="w-8 h-8 text-green-500 stroke-current" fill="none" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
                        </svg>
                        <div class="ml-3">
                            <div class="font-bold text-left text-black dark:text-gray-50">¡Se agregó al carrito!</div>
                            <a href="carito.jsp" class="w-full text-green-500 underline hover:text-green-600 dark:text-gray-300 mt-1">Ir al carrito</a>
                        </div>
                    </div>
                    <button onclick="document.getElementById('alerta-agregado').style.display = 'none'" class="text-gray-500 hover:text-gray-700 dark:text-gray-300 dark:hover:text-gray-500">
                        <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                        </svg>
                    </button>
                </div>
            </div>
        </div>
        <% } %>
        <% } %>

        <div class="container mx-auto px-1 mt-14 mb-8">
            <div class="grid grid-cols-1 sm:grid-cols-3 gap-6">
                <div class="bg-white shadow-lg rounded-lg overflow-hidden sm:col-span-1 h-min">
                    <h3 class="text-lg font-semibold text-gray-800 p-4">Filtros</h3>
                    <div class="p-4">
                        <form action="productos.jsp" method="post">
                            <label for="marca" class="block text-sm font-medium text-gray-700 mb-2">Marca</label>
                            <select name="marca" class="block w-full p-2 border border-gray-300 rounded-md bg-white shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm" required>
                                <option value="">Seleccione una marca</option>
                                <option value="Todas">Todas</option>

                                <% for (Marca marca : marcas) {%>
                                <option value="<%= marca.getIdMarca()%>"><%= marca.getNombreMarca()%></option>
                                <% } %>
                            </select>
                            <button type="submit" class="mt-4 bg-yellow-600 hover:bg-yellow-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline">
                                Filtrar
                            </button>
                        </form>
                    </div>
                </div>

                <div class="grid grid-cols-2 sm:grid-cols-2 xl:grid-cols-3 gap-6 sm:col-span-2">
                    <!-- Aquí van los productos filtrados -->
                    <%
                        Connection connProductos = null;
                        PreparedStatement stmtProductos = null;
                        ResultSet rsProductos = null;
                        try {
                            // Establecer la conexión a la base de datos utilizando el método conectarBD
                            mantenimiento.conectarBD();
                            connProductos = mantenimiento.getConexion();

                            String marcaSeleccionada = request.getParameter("marca");
                            String sqlProductos;

                            if (marcaSeleccionada == null || "Todas".equals(marcaSeleccionada)) {
                                sqlProductos = "SELECT P.id_producto, P.descripcion, P.precio, P.cantidad, P.url_imagen, M.id_marca, M.nombre_marca FROM Productos AS P JOIN Marca AS M ON P.marca_id = M.id_marca;";
                                stmtProductos = connProductos.prepareStatement(sqlProductos);
                            } else {
                                sqlProductos = "SELECT P.id_producto, P.descripcion, P.precio, P.cantidad, P.url_imagen, M.id_marca, M.nombre_marca FROM Productos AS P JOIN Marca AS M ON P.marca_id = M.id_marca WHERE M.id_marca = ?;";
                                stmtProductos = connProductos.prepareStatement(sqlProductos);
                                stmtProductos.setString(1, marcaSeleccionada);
                            }

                            rsProductos = stmtProductos.executeQuery();

                            while (rsProductos.next()) {
                                int cantidadDisponible = rsProductos.getInt("cantidad");
                                if (cantidadDisponible > 0) {
                    %>
                    <div class="card bg-base-100 shadow-xl">
                        <figure class="relative">
                            <a href="producto.jsp?id_producto=<%= rsProductos.getInt("id_producto")%>">
                                <img src="${pageContext.request.contextPath}<%= rsProductos.getString("url_imagen")%>" alt="<%= rsProductos.getString("descripcion")%>" class="transition duration-300 transform hover:scale-105 hover:shadow-yellow-400">
                            </a>
                        </figure>

                        <div class="card-body">
                            <h2 class="text-xl stat-value"><%= rsProductos.getString("nombre_marca")%></h2>
                            <p><%= rsProductos.getString("descripcion")%></p>
                            <div class="rating">
                                <input type="radio" name="rating-1" class="mask mask-star-2 bg-yellow-400" />
                                <input type="radio" name="rating-1" class="mask mask-star-2 bg-yellow-400" />
                                <input type="radio" name="rating-1" class="mask mask-star-2 bg-yellow-400" />
                                <input type="radio" name="rating-1" class="mask mask-star-2 bg-yellow-400" checked />
                                <input type="radio" name="rating-1" class="mask mask-star-2 bg-yellow-400" />
                            </div>
                            <form action="enviocarito.jsp" method="post">
                                <input type="hidden" name="id_producto" value="<%= rsProductos.getInt("id_producto")%>">
                                <div class="flex flex-col justify-between items-center mt-4">

                                    <div class="flex items-center ">
                                        <span class="text-sm">Cantidad:</span>
                                        <input type="number" name="cantidad" min="1" value="1" class="ml-2 w-16 border border-yellow-400 rounded-md text-center" />
                                    </div>
                                    <div class="mt-2 sm:mt-0">
                                        <div class="text-2xl stat-value">S/ <%= rsProductos.getString("precio")%></div>
                                        <div class="text-sm text-gray-500 text-center">Precio Online</div>
                                    </div>
                                </div>
                                <div class="card-actions justify-end">
                                    <button class="btn bg-gradient-to-r from-yellow-500 to-orange-500 text-white w-full rounded-full">Añadir a Carrito</button>
                                </div>
                            </form>
                        </div>
                    </div>            
                    <%
                    } else {%>
                    <div class="card bg-base-100 shadow-xl relative">
                        <div class="absolute top-0 left-0 bg-red-500 text-white px-2 py-1 text-xl font-bold rounded-tl-xl rounded-ee-xl z-10">Agotado</div>
                        <figure class="relative">
                            <img src="${pageContext.request.contextPath}<%= rsProductos.getString("url_imagen")%>"  alt="<%= rsProductos.getString("descripcion")%>" class="opacity-70" />
                        </figure>
                        <div class="card-body">
                            <h2 class="text-xl stat-value"><%= rsProductos.getString("nombre_marca")%></h2>
                            <p><%= rsProductos.getString("descripcion")%></p>
                            <div class="rating">
                                <input type="radio" name="rating-4" class="mask mask-star-2 bg-yellow-400" />
                                <input type="radio" name="rating-4" class="mask mask-star-2 bg-yellow-400" />
                                <input type="radio" name="rating-4" class="mask mask-star-2 bg-yellow-400" />
                                <input type="radio" name="rating-4" class="mask mask-star-2 bg-yellow-400" checked />
                                <input type="radio" name="rating-4" class="mask mask-star-2 bg-yellow-400" />
                            </div>
                            <div class="flex flex-col justify-between items-center mt-4">
                                <div class="flex items-center">
                                    <span class="text-sm">Cantidad:</span>
                                    <input type="number" min="1" value="1" class="ml-2 w-16 border border-yellow-400 rounded-md text-center" disabled />
                                </div>
                                <div class="mt-2 sm:mt-0">
                                    <div class="text-2xl stat-value">S/ <%= rsProductos.getDouble("precio")%></div>
                                    <div class="text-sm text-gray-500 text-center">Precio Online</div>
                                </div>
                            </div>
                            <div class="card-actions justify-end">
                                <button class="btn bg-red-500 text-white w-full rounded-full cursor-not-allowed " >Agotado</button>
                            </div>
                        </div>
                    </div>
                    <%
                                }
                            }
                        } catch (SQLException e) {
                            e.printStackTrace();
                        } finally {
                            // Cerrar recursos en el bloque finally
                            mantenimiento.cerrarBD();
                        }
                    %>
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
        <script src="js/ValidacionUsuario.js"></script>
        <script>
            function cerrarVentana() {
                document.getElementById('ventanaEmergente').style.display = 'none';
            }
        </script>     
    </body>
</html>
