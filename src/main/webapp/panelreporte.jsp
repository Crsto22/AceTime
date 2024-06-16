<%@ page import="datos.Mantenimiento" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.naming.*, javax.sql.*" %>
<%@ page import="datos.Marca" %>
<%
    // Obtaining session variables
    Integer idUsuario = (Integer) session.getAttribute("idUsuario");
    String nombreUsuario = (String) session.getAttribute("nombreUsuario");
    String rol = (String) session.getAttribute("rol");

    if ("cliente".equals(rol) || rol == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    Mantenimiento mantenimiento2 = new Mantenimiento();
mantenimiento2.conectarBD();
List<Marca> marcas = mantenimiento2.obtenerMarcas();
mantenimiento2.cerrarBD();
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Reportes</title>
        <link href="./output.css" rel="stylesheet" />
        <link href="https://cdn.jsdelivr.net/npm/daisyui@4.12.2/dist/full.min.css" rel="stylesheet" type="text/css" />
        <script src="https://cdn.tailwindcss.com"></script>
        <link rel='stylesheet' href='https://cdn-uicons.flaticon.com/2.4.0/uicons-solid-rounded/css/uicons-solid-rounded.css'>
        <link rel='stylesheet'
              href='https://cdn-uicons.flaticon.com/2.4.0/uicons-regular-straight/css/uicons-regular-straight.css'>
        <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
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
                <ul class="mt-10 space-y-3 overflow-x-auto">
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
                    <li onclick="window.location.href = 'panelventas.jsp'"
                        class="relative flex cursor-pointer space-x-2 rounded-md py-4 px-10 text-gray-600 hover:bg-orange-400 hover:text-white  ">
                        <i class="fi fi-rs-point-of-sale-bill text-xl"></i>
                        <span>Ventas</span>
                    </li>
                    <li
                        class="relative flex cursor-pointer space-x-2 rounded-md py-4 px-10 bg-orange-400 text-white ">
                        <i class="fi fi-rs-signal-alt-2 text-xl"></i>
                        <span>Reportes</span>
                    </li>             

                    <li onclick="window.location.href = 'panelmarcas.jsp'" 
                        class="relative flex cursor-pointer space-x-2 rounded-md py-4 px-10 text-gray-600 hover:bg-orange-400 hover:text-white ">
                        <i class="fi fi-rs-tags text-xl"></i>                 
                        <span>Marcas</span>
                    </li>
                    <li  onclick="window.location.href = 'panelproveedores.jsp'" 
                         class="relative flex cursor-pointer space-x-2 rounded-md py-4 px-10 text-gray-600 hover:bg-orange-400 hover:text-white ">
                        <i class="fi fi-rs-supplier-alt text-xl"></i>                
                        <span>Proveedores</span>
                    </li>
                    <li onclick="window.location.href = 'panelcuenta.jsp'" 
                        class="relative flex cursor-pointer space-x-2 rounded-md py-4 px-10  text-gray-600 hover:bg-orange-400 hover:text-white">
                        <i class="fi fi-rs-admin-alt text-xl"></i>                    
                        <span>Cuenta</span>
                    </li>
                </ul>
            </div>
            <div id="main-content" class="md:ml-72 p-8">
                <div role="tablist" class="tabs tabs-lifted mt-14">
                    <!-- Tab 1 -->
                    <input type="radio" name="my_tabs_2" role="tab" class="tab font-bold  text-base" aria-label="Reportes Ventas" checked />
                    <div role="tabpanel" class="tab-content bg-base-100 border-base-300 rounded-box p-6 ">
                        <form action="ReporteVentas" id="reporteForm" class="flex justify-center space-x-4" target="_blank">
                            <div>
                                <label for="fecha-inicio" class="block text-sm font-medium text-gray-700">Fecha de Inicio</label>
                                <input type="text" id="fecha-inicio" name="fecha-inicio" class="input input-bordered w-full max-w-xs mt-1 flatpickr" />
                            </div>
                            <div>
                                <label for="fecha-fin" class="block text-sm font-medium text-gray-700">Fecha de Salida</label>
                                <input type="text" id="fecha-fin" name="fecha-fin" class="input input-bordered w-full max-w-xs mt-1 flatpickr" />
                            </div>
                            <button type="submit" class="btn bg-orange-500 text-white hover:bg-orange-600 self-end">Descargar Reporte <i class="fi fi-rs-down-to-line"></i></button>
                        </form>

                        <div id="toastContainer" class="fixed top-24 right-4 md:top-22 md:right-6 lg:top-24 lg:right-8 h-auto w-11/12 md:w-2/3 lg:w-1/2 max-w-sm mx-auto"></div>

                    </div>

                    <!-- Tab 2 -->
                    <input type="radio" name="my_tabs_2" role="tab" class="tab font-bold  text-base" aria-label="Reportes Productos" />
                    <div role="tabpanel" class="tab-content bg-base-100 border-base-300 rounded-box p-6">
                        <form action="ReporteProductos" method="GET" class="flex items-center space-x-4" id="reportForm" target="_blank">
                            <div class="flex items-center space-x-2">
                                <label for="marca" class="block text-sm font-medium text-gray-700">Marca</label>
                                <select id="marca" name="marca" class="select select-bordered max-w-xs">
                                    <option value="todos">Todos</option>
                                    <% for (Marca marca : marcas) { %>
                                    <option value="<%= marca.getIdMarca() %>"><%= marca.getNombreMarca() %></option>
                                    <% } %>
                                </select>
                            </div>
                            <button type="submit" class="btn bg-orange-500 text-white hover:bg-orange-600">Descargar Reporte <i class="fi fi-rs-down-to-line"></i></button>
                        </form>
                    </div>
                </div>
            </div>
                                
            <script>
                const menuBtn = document.getElementById("menu-btn");
                const sidebar = document.getElementById("sidebar");
                const body = document.body;

                menuBtn.addEventListener("click", (event) => {
                    // Evita que el evento de clic se propague al cuerpo del documento
                    event.stopPropagation();

                    sidebar.classList.toggle("-translate-x-full");
                    sidebar.classList.toggle("translate-x-0");
                });

                body.addEventListener("click", () => {
                    // Cierra el sidebar si está abierto
                    if (!sidebar.classList.contains("-translate-x-full")) {
                        sidebar.classList.add("-translate-x-full");
                        sidebar.classList.remove("translate-x-0");
                    }
                });
            </script>
            <script src="js/sidebar.js"></script>
            <script>
                document.addEventListener('DOMContentLoaded', function () {
                    var startDatePicker = flatpickr('#fecha-inicio', {
                        dateFormat: 'Y-m-d',
                        onChange: function (selectedDates, dateStr, instance) {
                            endDatePicker.set('minDate', dateStr);
                        }
                    });

                    var endDatePicker = flatpickr('#fecha-fin', {
                        dateFormat: 'Y-m-d',
                        onChange: function (selectedDates, dateStr, instance) {
                            startDatePicker.set('maxDate', dateStr);
                        }
                    });

                    document.getElementById('reporteForm').addEventListener('submit', function (event) {
                        event.preventDefault(); // Prevent the form from submitting normally

                        var fechaInicio = document.getElementById('fecha-inicio').value;
                        var fechaFin = document.getElementById('fecha-fin').value;
                        var toastContainer = document.getElementById('toastContainer');

                        // Clear previous toast messages
                        toastContainer.innerHTML = '';

                        if (!fechaInicio || !fechaFin) {
                            // Create the toast message
                            var toast = document.createElement('div');
                            toast.className = 'fixed top-24 right-4 md:top-22 md:right-6 lg:top-24 lg:right-8 h-auto w-11/12 md:w-2/3 lg:w-1/2 max-w-sm mx-auto bg-white border border-gray-200 rounded-xl shadow-lg dark:bg-neutral-800 dark:border-neutral-700 animate__animated animate__fadeInDown';
                            toast.setAttribute('role', 'alert');

                            toast.innerHTML = `
                    <div class="flex p-4">
                        <div class="flex-shrink-0">
                            <svg class="flex-shrink-0 size-4 text-red-500 mt-0.5" xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                                <path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0zM5.354 4.646a.5.5 0 1 0-.708.708L7.293 8l-2.647 2.646a.5.5 0 0 0 .708.708L8 8.707l2.646 2.647a.5.5 0 0 0 .708-.708L8 7.293 5.354 4.646z"></path>
                            </svg>
                        </div>
                        <div class="ms-3">
                            <p class="text-sm text-gray-700 dark:text-neutral-400 ml-2">
                                Seleccione la fecha de inicio y salida
                            </p>
                        </div>
                    </div>
                `;
                            toastContainer.appendChild(toast);

                            // Optionally, set a timeout to remove the toast after a few seconds
                            setTimeout(function () {
                                toast.remove();
                            }, 3000);
                        } else {
                            // If both dates are provided, submit the form
                            event.target.submit();
                        }
                    });
                });
            </script>
    </body>
</html>