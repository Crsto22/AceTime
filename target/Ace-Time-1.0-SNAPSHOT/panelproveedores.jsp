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
        <script>
            function consultarRUC() {
                var ruc = document.getElementById("ruc_proveedor").value;

                // Crear el cuerpo de la solicitud
                var requestBody = {
                    rucInput: ruc
                };

                fetch('ConsultaRUC', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(requestBody)
                })
                        .then(response => response.json())
                        .then(data => {
                            document.getElementById("nombre_proveedor").value = data.nombreEmpresa;
                        })
                        .catch(error => {
                            console.error('Error:', error);
                            document.getElementById("nombre_proveedor").value = "ERROR";
                        });
            }
        </script>
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
                    <li onclick="window.location.href = 'panelreporte.jsp'"
                        class="relative flex cursor-pointer space-x-2 rounded-md py-4 px-10  text-gray-600 hover:bg-orange-400 hover:text-white">
                        <i class="fi fi-rs-signal-alt-2 text-xl"></i>
                        <span>Reportes</span>
                    </li>             

                    <li onclick="window.location.href = 'panelmarcas.jsp'" 
                        class="relative flex cursor-pointer space-x-2 rounded-md py-4 px-10 text-gray-600 hover:bg-orange-400 hover:text-white ">
                        <i class="fi fi-rs-tags text-xl"></i>                 
                        <span>Marcas</span>
                    </li>
                    <li  
                        class="relative flex cursor-pointer space-x-2 rounded-md py-4 px-10 text-gray-600 bg-orange-400 text-white">
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
                <div class="container mx-auto mt-14">
                    <h1 class="text-3xl font-bold text-gray-800">Lista de Proveedores</h1>
                    <div class="flex justify-end gap-2 items-center mb-4">
                        <button class="btn btn-success text-white" onclick="my_modal_3.showModal()"> <i
                                class="fi fi-rs-plus"></i> Agregar</button>
                        <label class="input input-bordered flex items-center gap-2">
                            <input type="text" id="searchInput" class="grow" placeholder="Buscar por Nombre" onkeyup="filterTable()" />
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" fill="currentColor" class="w-4 h-4 opacity-70">
                            <path fill-rule="evenodd" d="M9.965 11.026a5 5 0 1 1 1.06-1.06l2.755 2.754a.75.75 0 1 1-1.06 1.06l-2.755-2.754ZM10.5 7a3.5 3.5 0 1 1-7 0 3.5 3.5 0 0 1 7 0Z" clip-rule="evenodd" />
                            </svg>
                        </label>       

                        <dialog id="my_modal_3" class="modal">
                            <div class="modal-box">
                                <form method="dialog">
                                    <button class="btn btn-sm btn-circle btn-ghost absolute right-2 top-2">
                                        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" /></svg>

                                    </button>
                                </form>
                                <div class="p-8 rounded-lg  max-w-md w-full">
                                    <h2 class="text-2xl font-bold mb-6 text-gray-800">Agregar Nuevo Proveedor</h2>
                                    <form action="agregarproveedor.jsp" method="post" class="space-y-4 p-4 rounded-lg">
                                        <div class="form-control">
                                            <label for="nombre_proveedor" class="label">
                                                <span class="label-text">Nombre del Proveedor</span>
                                            </label>
                                            <input type="text" id="nombre_proveedor" name="nombre_proveedor" class="input input-bordered w-full" placeholder="Nombre del proveedor" required>
                                        </div>

                                        <div class="form-control">
                                            <label for="telefono_proveedor" class="label">
                                                <span class="label-text">Teléfono</span>
                                            </label>
                                            <input type="tel" id="telefono_proveedor" name="telefono_proveedor" class="input input-bordered w-full" placeholder="Teléfono del proveedor" maxlength="9" pattern="[0-9]{9}">
                                        </div>

                                        <div class="form-control">
                                            <label for="correo_proveedor" class="label">
                                                <span class="label-text">Correo Electrónico</span>
                                            </label>
                                            <input type="email" id="correo_proveedor" name="correo_proveedor" class="input input-bordered w-full" placeholder="Correo electrónico del proveedor">
                                        </div>

                                        <div class="form-control">
                                            <label for="ruc_proveedor" class="label">
                                                <span class="label-text">RUC</span>
                                            </label>
                                            <div class="relative form-control">
                                                <input type="text" id="ruc_proveedor" name="ruc_proveedor" class="input input-bordered w-full pr-20" placeholder="Número de RUC" maxlength="11" required>
                                                <button type="button" onclick="consultarRUC()" class="absolute inset-y-0 right-0 px-4 text-white bg-green-500 hover:bg-green-600 rounded-r-lg flex items-center">Buscar</button>
                                            </div>
                                        </div>

                                        <button type="submit" class="btn btn-success text-white w-full">Añadir Proveedor</button>
                                    </form>

                                </div>
                            </div>
                        </dialog>
                    </div>
                    <div class="overflow-x-auto bg-white shadow-md rounded-lg">
                        <table class="table w-full">
                            <thead>
                                <tr class="bg-gray-200">
                                    <th class="px-4 py-2 text-gray-600">ID</th>
                                    <th class="px-4 py-2 text-gray-600">Nombre del Proveedor</th>
                                    <th class="px-4 py-2 text-gray-600">Teléfono</th>
                                    <th class="px-4 py-2 text-gray-600">Correo Electrónico</th>
                                    <th class="px-4 py-2 text-gray-600">RUC</th>
                                    <th class="px-4 py-2 text-gray-600">Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                Mantenimiento mantenimiento = new Mantenimiento();
                Connection connection = null;
                PreparedStatement statement = null;
                ResultSet resultSet = null;

                try {
                    mantenimiento.conectarBD();
                    connection = mantenimiento.getConexion();
                    statement = connection.prepareStatement("SELECT * FROM Proveedores WHERE estado = 'disponible';");
                    resultSet = statement.executeQuery();
                    
                    while (resultSet.next()) {
                                %>
                                <tr class="border-b">
                                    <td class="px-4 py-2 text-gray-700"><%= resultSet.getInt("id_proveedor") %></td>
                                    <td class="px-4 py-2 text-gray-700"><%= resultSet.getString("nombre_proveedor") %></td>
                                    <td class="px-4 py-2 text-gray-700"><%= resultSet.getString("telefono_proveedor") %></td>
                                    <td class="px-4 py-2 text-gray-700"><%= resultSet.getString("correo_proveedor") %></td>
                                    <td class="px-4 py-2 text-gray-700"><%= resultSet.getString("ruc_proveedor") %></td>
                                    <td class="px-4 py-2">
                                        <!-- BotÃ³n para editar -->
                                        <button class="btn text-white btn-warning btn-sm mr-2"
                                                onclick="document.getElementById('edit_modal_<%= resultSet.getInt("id_proveedor") %>').showModal()">
                                            <i class="fi fi-rs-edit"></i>
                                        </button>

                                        <!-- Modal para editar -->
                                        <dialog id="edit_modal_<%= resultSet.getInt("id_proveedor") %>" class="modal">
                                            <div class="modal-box">
                                                <form method="dialog">
                                                    <button class="btn btn-sm btn-circle btn-ghost absolute right-2 top-2">
                                                        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                                                        </svg>
                                                    </button>
                                                </form>
                                                <div class="p-8 rounded-lg max-w-md w-full">
                                                    <h2 class="text-2xl font-bold mb-6 text-gray-800">Editar Proveedor</h2>
                                                    <form action="editarProveedor.jsp" method="post">
                                                        <input type="hidden" name="id_proveedor" value="<%= resultSet.getInt("id_proveedor") %>">
                                                        <div class="mb-4">
                                                            <label for="nombre_proveedor" class="block text-gray-700 mb-2">Nombre del Proveedor</label>
                                                            <input type="text" id="nombre_proveedor" name="nombre_proveedor" class="input input-bordered w-full" placeholder="Nombre del proveedor" value="<%= resultSet.getString("nombre_proveedor") %>" required>
                                                        </div>
                                                        <div class="mb-4">
                                                            <label for="telefono_proveedor" class="block text-gray-700 mb-2">Teléfono</label>
                                                            <input type="text" id="telefono_proveedor" name="telefono_proveedor" class="input input-bordered w-full" placeholder="Teléfono del proveedor" value="<%= resultSet.getString("telefono_proveedor") %>">
                                                        </div>
                                                        <div class="mb-4">
                                                            <label for="correo_proveedor" class="block text-gray-700 mb-2">Correo Electrónico</label>
                                                            <input type="email" id="correo_proveedor" name="correo_proveedor" class="input input-bordered w-full" placeholder="Correo electrónico del proveedor" value="<%= resultSet.getString("correo_proveedor") %>">
                                                        </div>
                                                        <div class="mb-4">
                                                            <label for="ruc_proveedor" class="block text-gray-700 mb-2">RUC</label>
                                                            <input type="text" id="ruc_proveedor" name="ruc_proveedor" class="input input-bordered w-full" placeholder="RUC del proveedor" value="<%= resultSet.getString("ruc_proveedor") %>">
                                                        </div>
                                                        <button type="submit" class="btn btn-success text-white w-full">Editar Proveedor</button>
                                                    </form>
                                                </div>
                                            </div>
                                        </dialog>

                                        <!-- BotÃ³n para eliminar -->
                                        <button class="btn text-white btn-error btn-sm"
                                                onclick="document.getElementById('delete_modal_<%= resultSet.getInt("id_proveedor") %>').showModal()">
                                            <i class="fi fi-rs-trash"></i>
                                        </button>

                                        <!-- Modal para eliminar -->
                                        <dialog id="delete_modal_<%= resultSet.getInt("id_proveedor") %>" class="modal">
                                            <div class="modal-box">
                                                <div class="flex items-center mb-4">
                                                    <svg xmlns="http://www.w3.org/2000/svg" id="Layer_1" style="enable-background:new 0 0 128 128 ; width: 40px;" version="1.1" viewBox="0 0 128 128" xml:space="preserve">
                                                    <style type="text/css">
                                                        .st0 {
                                                            fill: #C93636;
                                                        }
                                                        .st1 {
                                                            fill: #FFFFFF;
                                                        }
                                                    </style>
                                                    <circle class="st0" cx="64" cy="64" r="64"/>
                                                    <path class="st1" d="M100.3,90.4L73.9,64l26.3-26.4c0.4-0.4,0.4-1,0-1.4l-8.5-8.5c-0.4-0.4-1-0.4-1.4,0L64,54.1L37.7,27.8  c-0.4-0.4-1-0.4-1.4,0l-8.5,8.5c-0.4,0.4-0.4,1,0,1.4L54,64L27.7,90.3c-0.4,0.4-0.4,1,0,1.4l8.5,8.5c0.4,0.4,1.1,0.4,1.4,0L64,73.9  l26.3,26.3c0.4,0.4,1.1,0.4,1.5,0.1l8.5-8.5C100.7,91.4,100.7,90.8,100.3,90.4z"/>
                                                    </svg>
                                                    <h3 class="ml-6 font-bold text-lg">¿Estás seguro de eliminar el proveedor <%= resultSet.getString("nombre_proveedor") %>?</h3>
                                                </div>
                                                <p class="py-4">Esta acción no se puede deshacer.</p>
                                                <div class="flex justify-end">
                                                    <button class="btn btn- mr-2 bg-slate-200" onclick="document.getElementById('delete_modal_<%= resultSet.getInt("id_proveedor") %>').close()">Cancelar</button>
                                                    <form action="eliminarproveedor.jsp" method="post">
                                                        <input type="hidden" name="id_proveedor" value="<%= resultSet.getInt("id_proveedor") %>">
                                                        <button type="submit" class="btn btn-error text-white">Aceptar</button>
                                                    </form>
                                                </div>
                                            </div>
                                        </dialog>
                                    </td>
                                </tr>
                                <%
                                        }
                                    } catch (SQLException e) {
                                        e.printStackTrace();
                                    } finally {
                                        // Cerrar ResultSet
                                        if (resultSet != null) {
                                            try {
                                                resultSet.close();
                                            } catch (SQLException e) {
                                                e.printStackTrace();
                                            }
                                        }

                                        // Cerrar PreparedStatement
                                        if (statement != null) {
                                            try {
                                                statement.close();
                                            } catch (SQLException e) {
                                                e.printStackTrace();
                                            }
                                        }

                                        // Cerrar Connection
                                        if (connection != null) {
                                            try {
                                                connection.close();
                                            } catch (SQLException e) {
                                                e.printStackTrace();
                                            }
                                        }
                                    }
                                %>

                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <script src="js/sidebar.js"></script>
            <script>
                                                        function filterTable() {
                                                            var input, filter, table, tr, td, i, txtValue;
                                                            input = document.getElementById("searchInput");
                                                            filter = input.value.toUpperCase();
                                                            table = document.querySelector(".table");
                                                            tr = table.getElementsByTagName("tr");

                                                            for (i = 1; i < tr.length; i++) {
                                                                tr[i].style.display = "none"; // Ocultar la fila inicialmente
                                                                td = tr[i].getElementsByTagName("td")[1]; // Seleccionar solo la tercera columna (índice 2)
                                                                if (td) {
                                                                    txtValue = td.textContent || td.innerText;
                                                                    if (txtValue.toUpperCase().indexOf(filter) > -1) {
                                                                        tr[i].style.display = ""; // Mostrar la fila si coincide con la descripción
                                                                    }
                                                                }
                                                            }
                                                        }
            </script>
<script>
    function consultarRUC() {
        var ruc = document.getElementById("ruc_proveedor").value;

        if (!ruc) {
            alert('Por favor, ingrese un RUC.');
            return;
        }
        
        // Crear el cuerpo de la solicitud
        var requestBody = {
            rucInput: ruc
        };

        fetch('ConsultaRUC', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(requestBody)
        })
        .then(response => response.json())
        .then(data => {
            // Llenar el campo 'nombre_proveedor' con el nombre de la empresa
            document.getElementById("nombre_proveedor").value = data.nombreEmpresa;
        })
        .catch(error => {
            console.error('Error:', error);
            document.getElementById("nombre_proveedor").value = "Error al consultar el RUC";
        });
    }
</script>

    </body>
</html>