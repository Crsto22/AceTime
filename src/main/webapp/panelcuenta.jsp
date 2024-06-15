<%@ page import="datos.Mantenimiento" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.naming.*, javax.sql.*" %>
<%
    // Obtaining session variables
    Integer idUsuario = (Integer) session.getAttribute("idUsuario");
    String nombreUsuario = (String) session.getAttribute("nombreUsuario");
    String rol = (String) session.getAttribute("rol");

    if ("cliente".equals(rol) || rol == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Document</title>
        <link href="./output.css" rel="stylesheet" />
        <link href="https://cdn.jsdelivr.net/npm/daisyui@4.12.2/dist/full.min.css" rel="stylesheet" type="text/css" />
        <script src="https://cdn.tailwindcss.com"></script>
        <link rel='stylesheet' href='https://cdn-uicons.flaticon.com/2.4.0/uicons-solid-rounded/css/uicons-solid-rounded.css'>
        <link rel='stylesheet'
              href='https://cdn-uicons.flaticon.com/2.4.0/uicons-regular-straight/css/uicons-regular-straight.css'>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
    </head>
    <body class="overflow-x-hidden">
        <div class="min-h-screen w-screen bg-gray-100">
            <div class="navbar fixed bg-orange-100 z-[50]">
                <div class="flex-1">
                    <button id="menu-btn" class="fixed top-4 left-4 p-2 rounded-md md:hidden">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24"
                             stroke="currentColor" stroke-width="2">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M4 6h16M4 12h16M4 18h16" />
                        </svg>
                    </button>
                </div>

                <div class="dropdown dropdown-end">
                    <div>
                        <div class="indicator">
                            <span class="text-gray-500">Hola, <span class="font-bold"><%= session.getAttribute("nombreUsuario") %></span></span>
                        </div>
                    </div>

                </div>
                <div class="flex-none">
                    <div class="dropdown dropdown-end">
                        <div tabindex="0" role="button" class="btn btn-ghost btn-circle avatar">
                            <div class="w-10 rounded-full ">
                                <img alt="usario" src="img/avatar.png" />
                            </div>

                        </div>
                        <ul tabindex="0"
                            class="menu menu-sm dropdown-content mt-3 z-[50] p-2 shadow bg-base-100 rounded-box w-52">
                            <li><a href="CambioRol.jsp"><i class="fi fi-rs-convert-shapes"></i>Cambiar de Rol</a></li>
                            <li><a href="cerrarsesion.jsp"><i class="fi fi-rs-exit"></i>Cerrar Sesion</a></li>
                        </ul>
                    </div>
                </div>
            </div>
            <div id="sidebar"
                 class="fixed left-0 flex h-screen w-72 flex-col overflow-hidden bg-white text-white transition-transform duration-300 transform -translate-x-full md:translate-x-0 md:sidebar-visible z-50">
                <div class="flex justify-center mt-8">
                    <img src="img/ace.png" class="w-44 object-contain" />
                </div>
                <ul class="mt-10 space-y-3">
                    <li onclick="window.location.href = 'indexpanel.jsp'" 
                        class="relative flex cursor-pointer space-x-2 rounded-md py-4 px-10 text-gray-600 hover:bg-orange-400 hover:text-white ">
                        <span>
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24"
                                 stroke="currentColor" stroke-width="2">
                            <path stroke-linecap="round" stroke-linejoin="round"
                                  d="M4 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2V6zM14 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2V6zM4 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2v-2zM14 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2v-2z" />
                            </svg>
                        </span>
                        <span>Dashboard</span>
                    </li>
                    <li onclick="window.location.href = 'panelproductos.jsp'" 
                        class="relative flex cursor-pointer space-x-2 rounded-md py-4 px-10 text-gray-600 hover:bg-orange-400 hover:text-white ">
                        <i class="fi fi-rs-box-open-full text-xl"></i>
                        <span>Productos</span>
                    </li>
                    <li  onclick="window.location.href = 'panelventas.jsp'"
                        class="relative flex cursor-pointer space-x-2 rounded-md py-4 px-10 text-gray-600 hover:bg-orange-400 hover:text-white  ">
                        <i class="fi fi-rs-point-of-sale-bill text-xl"></i>
                        <span>Ventas</span>
                    </li>
                    <li onclick="window.location.href = 'panelreporte.jsp'"
                        class="relative flex cursor-pointer space-x-2 rounded-md py-4 px-10 text-gray-600 hover:bg-orange-400 hover:text-white  ">
                        <i class="fi fi-rs-signal-alt-2 text-xl"></i>
                        <span>Reportes</span>
                    </li>             
                    
                     <li onclick="window.location.href = 'panelmarcas.jsp'" 
                        class="relative flex cursor-pointer space-x-2 rounded-md py-4 px-10 text-gray-600 hover:bg-orange-400 hover:text-white ">
                        <i class="fi fi-rs-tags text-xl"></i>                 
                        <span>Marcas</span>
                    </li>
                    <li  onclick="window.location.href = 'panelproveedores.jsp'" 
                        class="relative flex cursor-pointer space-x-2 rounded-md py-4 px-10 text-gray-600 text-gray-600 hover:bg-orange-400 hover:text-white  ">
                        <i class="fi fi-rs-supplier-alt text-xl"></i>                
                        <span>Proveedores</span>
                    </li>
                    <li
                        class="relative flex cursor-pointer space-x-2 rounded-md py-4 px-10 bg-orange-400 text-white  ">
                        <i class="fi fi-rs-admin-alt text-xl"></i>                    
                        <span>Cuenta</span>
                    </li>
                </ul>
            </div>
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

                 mantenimiento2.cerrarBD();%>

            <div id="main-content" class="md:ml-72 p-8">
                <div class="container mx-auto mt-10 bg-white">
                    <div class="card shadow-lg p-6 rounded-lg">
                        <h2 class="text-2xl font-bold mb-4">Configuración de Cuenta</h2>
                        <div>
                            <p class="mb-2">Nombre de usuario: <span class="font-semibold"><%= session.getAttribute("nombre_usuario") %></span></p>
                            <p class="mb-2">Apellidos: <span class="font-semibold"><%= session.getAttribute("apellidos") %></span></p>
                            <p class="mb-2">Nombres: <span class="font-semibold"><%= session.getAttribute("nombre") %></span></p>
                            <p class="mb-2">Correo Electronico: <span class="font-semibold"><%= session.getAttribute("correo") %></span></p>
                            <p class="mb-2">Numero de documento: <span class="font-semibold"><%= session.getAttribute("Num_Documento") %></span></p>
                            <p class="mb-2">Telefono: <span class="font-semibold"><%= session.getAttribute("telefono") %></span></p>

                        </div>
                        <button class="btn btn-error text-white w-max" onclick="my_modal_3.showModal()">Editar Datos</button>
                        <dialog id="my_modal_3" class="modal">
                            <div class="modal-box">
                                <form method="dialog">
                                    <button class="btn btn-sm btn-circle btn-ghost absolute right-2 top-2">
                                        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" /></svg>

                                    </button>
                                </form>

                                <h1 class="text-2xl font-bold mb-4">Editar Datos</h1>
                                <form id="registroForm" class="mt-8 space-y-6" action="procesarActualizarUsuario.jsp" method="POST">
                                    <div>
                                        <label for="nombreUsuario" class="block text-sm font-medium text-gray-700">Nombre de usuario</label>
                                        <input id="nombreUsuario" name="nombreUsuario" value="<%= session.getAttribute("nombre_usuario") %>"  type="text" required class="mt-1 appearance-none rounded-md relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm" placeholder="Ingrese el nombre de usuario">
                                        <span id="errorNombreUsuario" class="text-red-500 text-sm hidden">El nombre de usuario debe ser una sola palabra.</span>
                                    </div>
                                    <div class="grid grid-cols-2 gap-4">
                                        <div>
                                            <label for="nombre" class="block text-sm font-medium text-gray-700">Nombre</label>
                                            <input id="nombre" name="nombre" type="text" value="<%= session.getAttribute("nombre") %>" required class="mt-1 appearance-none rounded-md relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm" placeholder="Ingrese su nombre">
                                        </div>
                                        <div>
                                            <label for="apellido" class="block text-sm font-medium text-gray-700">Apellido</label>
                                            <input id="apellido" name="apellido" type="text" value="<%= session.getAttribute("apellidos") %>" required class="mt-1 appearance-none rounded-md relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm" placeholder="Ingrese su apellido">
                                        </div>
                                    </div>
                                    <div>
                                        <label for="correo" class="block text-sm font-medium text-gray-700">Correo</label>
                                        <input id="correo" name="correo" type="email" required value="<%= session.getAttribute("correo") %>" class="mt-1 appearance-none rounded-md relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm" placeholder="Ingrese su correo">
                                    </div>
                                    <div>
                                        <label for="contrasena" class="block text-sm font-medium text-gray-700">Contraseña</label>
                                        <input id="contrasena" name="contrasena" type="password" value="<%= session.getAttribute("contrasena") %>" required class="mt-1 appearance-none rounded-md relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm" placeholder="Ingrese su contraseña">
                                    </div>
                                    <div class="grid grid-cols-2 gap-4">
                                        <div>
                                            <label for="tipoDocumento" class="block text-sm font-medium text-gray-700">Tipo Documento</label>
                                            <select id="tipoDocumento" name="tipoDocumento" required class="mt-1 appearance-none rounded-md relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm">
                                                <option value="1">DNI</option>
                                                <option value="2">Pasaporte</option>
                                            </select>
                                        </div>
                                        <div>
                                            <label for="numeroDocumento" class="block text-sm font-medium text-gray-700">Numero documento</label>
                                            <input id="numeroDocumento" name="numeroDocumento" value="<%= session.getAttribute("Num_Documento") %>" type="text" pattern="^[0-9]{8}$" maxlength="8" required class="mt-1 appearance-none rounded-md relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm" placeholder="Ingrese su número de documento">
                                        </div>
                                    </div>
                                    <div>
                                        <label for="telefono" class="block text-sm font-medium text-gray-700">Teléfono</label>
                                        <input id="telefono" name="telefono" type="tel" value="<%= session.getAttribute("telefono") %>" pattern="^[0-9]{9}$" maxlength="9" required class="mt-1 appearance-none rounded-md relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm" placeholder="Ingrese su teléfono">
                                    </div>
                                    <div>
                                        <button type="submit" class="w-full flex justify-center py-2 px-4 text-white bg-black text-xl font-semibold border px-4 py-2 rounded-lg hover:text-white hover:border-yellow-600 hover:bg-yellow-600 mb-4 md:mb-0">Actualizar</button>
                                    </div>
                                </form>
                            </div>
                        </dialog>           
                    </div>
                </div>
            </div>
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
                            <% } %>
                            
                            <script>
                                function cerrarAlerta() {
                                    var alerta = document.getElementById('alerta');
                                    alerta.style.display = 'none';
                                }
                            </script>
<script>
        document.addEventListener("DOMContentLoaded", function() {
            const form = document.getElementById("registroForm");
            const nombreUsuarioInput = document.getElementById("nombreUsuario");
            const errorNombreUsuario = document.getElementById("errorNombreUsuario");

            form.addEventListener("submit", function(event) {
                // Evita que el formulario se envíe si el nombre de usuario no es válido
                if (!isValidNombreUsuario(nombreUsuarioInput.value)) {
                    errorNombreUsuario.classList.remove("hidden");
                    event.preventDefault();
                } else {
                    errorNombreUsuario.classList.add("hidden");
                }
            });

            function isValidNombreUsuario(nombreUsuario) {
                // Verifica que el nombre de usuario no contenga espacios
                return /^[^\s]+$/.test(nombreUsuario);
            }
        });
    </script>
            <script src="js/sidebar.js"></script>
    </body>
</html>