<%@ page import="java.util.List" %>
<%@ page import="datos.Mantenimiento" %>
<%@ page import="datos.Marca" %>
<%@ page import="datos.Proveedor" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.naming.*, javax.sql.*" %>

<%
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

Mantenimiento mantenimiento3 = new Mantenimiento();
mantenimiento3.conectarBD();
List<Proveedor> proveedores = mantenimiento3.obtenerProveedores();
mantenimiento3.cerrarBD();
                         
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Productos</title>
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
                    <li
                        class="relative flex cursor-pointer space-x-2 rounded-md py-4 px-10  bg-orange-400 text-white">
                        <i class="fi fi-rs-box-open-full text-xl"></i>
                        <span>Productos</span>
                    </li>
                    <li onclick="window.location.href = 'panelventas.jsp'"  class="relative flex cursor-pointer space-x-2 rounded-md py-4 px-10 text-gray-600 hover:bg-orange-400 hover:text-white ">
                        <i class="fi fi-rs-point-of-sale-bill text-xl"></i>
                        <span>Ventas</span>
                    </li>
                    <li onclick="window.location.href = 'panelreporte.jsp'"
                        class="relative flex cursor-pointer space-x-2 rounded-md py-4 px-10 text-gray-600 hover:bg-orange-400 hover:text-white ">
                        <i class="fi fi-rs-signal-alt-2 text-xl"></i>
                        <span>Reportes</span>
                    </li>             

                    <li onclick="window.location.href = 'panelmarcas.jsp'" 
                        class="relative flex cursor-pointer space-x-2 rounded-md py-4 px-10 text-gray-600 hover:bg-orange-400 hover:text-white ">
                        <i class="fi fi-rs-tags text-xl"></i>                 
                        <span>Marcas</span>
                    </li>
                    <li  onclick="window.location.href = 'panelproveedores.jsp'" 
                         class="relative flex cursor-pointer space-x-2 rounded-md py-4 px-10 text-gray-600 hover:bg-orange-400 hover:text-white  ">
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
                <div>
                    <!-- Bot贸n para agregar producto -->
                    <div class="flex justify-between items-center mb-4 mt-14">
                        <button class="btn btn-success text-white flex items-center gap-2" onclick="my_modal_3.showModal()">
                            <i class="fi fi-rs-plus"></i> Agregar Producto
                        </button>
                        <label class="input input-bordered flex items-center gap-2">
                            <input type="text" id="searchInput" class="grow" placeholder="Buscar por ID o Nombre" onkeyup="filterTable()" />
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" fill="currentColor" class="w-4 h-4 opacity-70">
                            <path fill-rule="evenodd" d="M9.965 11.026a5 5 0 1 1 1.06-1.06l2.755 2.754a.75.75 0 1 1-1.06 1.06l-2.755-2.754ZM10.5 7a3.5 3.5 0 1 1-7 0 3.5 3.5 0 0 1 7 0Z" clip-rule="evenodd" />
                            </svg>
                        </label>  
                    </div>


                    <!-- Modal para agregar producto -->
                    <dialog id="my_modal_3" class="modal">
                        <div class="modal-box">
                            <form method="dialog">
                                <button class="btn btn-sm btn-circle btn-ghost absolute right-2 top-2">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                                    </svg>
                                </button>
                            </form>
                            <h1 class="text-2xl font-bold mb-4">Agregar Producto</h1>
                            <form action="AgregarProducto" method="POST" enctype="multipart/form-data">
                                <div class="mb-4">
                                    <label for="marcaEdit2" class="block text-sm font-semibold mb-2">Marca</label>
                                    <select name="marca" class="w-full px-4 py-2 border rounded-md focus:outline-none focus:border-blue-500" required>
                                        <option value="">Seleccione una marca</option>
                                        <% for (Marca marca : marcas) { %>
                                        <option value="<%= marca.getIdMarca() %>"><%= marca.getNombreMarca() %></option>
                                        <% } %>
                                    </select>
                                </div>

                                <div class="mb-4">
                                    <label for="descripcionEdit2" class="block text-sm font-semibold mb-2">Descripci髇</label>
                                    <textarea name="descripcion2" rows="4" class="w-full px-4 py-2 border rounded-md resize-none focus:outline-none focus:border-blue-500" placeholder="Ingrese la descripci髇" required></textarea>
                                </div>

                                <div class="mb-4">
                                    <label for="precioEdit2" class="block text-sm font-semibold mb-2">Precio</label>
                                    <input type="number" name="precio2" min="0" step="0.01" class="w-full px-4 py-2 border rounded-md focus:outline-none focus:border-blue-500" placeholder="Ingrese el precio" required>
                                </div>

                                <div class="mb-4">
                                    <label for="cantidadEdit2" class="block text-sm font-semibold mb-2">Cantidad</label>
                                    <input type="number" name="cantidad2" min="0" class="w-full px-4 py-2 border rounded-md focus:outline-none focus:border-blue-500" placeholder="Ingrese la cantidad" required>
                                </div>

                                <div class="mb-4">
                                    <label for="proveedorEdit" class="block text-sm font-semibold mb-2">Proveedor</label>
                                    <select name="proveedor" class="w-full px-4 py-2 border rounded-md focus:outline-none focus:border-blue-500" required>
                                        <option value="">Seleccione un proveedor</option>
                                        <% for (Proveedor proveedor : proveedores) { %>
                                        <option value="<%= proveedor.getIdProveedor() %>"><%= proveedor.getNombreProveedor() %></option>
                                        <% } %>
                                    </select>
                                </div>

                                <div class="mb-4">
                                    <label for="imagenEdit2" class="block text-sm font-semibold mb-2">Cargar Imagen</label>
                                    <input type="file" name="imagen2" accept="image/*" class="w-full px-4 py-2 border rounded-md focus:outline-none focus:border-blue-500" required>
                                </div>

                                <div class="text-right">
                                    <button type="submit" class="text-white bg-yellow-500 text-sm font-semibold border px-4 py-2 rounded-lg hover:text-yellow-600 hover:border-yellow-600 hover:bg-white transition duration-200">Guardar Cambios</button>
                                </div>
                            </form>
                        </div>
                    </dialog>
                </div>

                <div class="overflow-x-auto">
                    <table class="table w-full bg-white rounded-lg shadow-lg">
                        <thead class="bg-black text-white">
                            <tr>
                                <th class="p-3">ID</th>
                                <th class="p-3">Marca</th>
                                <th class="p-3">Descripci髇</th>
                                <th class="p-3">Precio</th>
                                <th class="p-3">Cantidad</th> 
                                <th class="p-3">Imagen</th>
                                <th class="p-3">Proveedor</th>
                                <th class="p-3">Acciones</th>
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
                                statement = connection.prepareStatement(
                                    "SELECT P.id_producto, P.descripcion, P.precio, P.cantidad, P.url_imagen, " +
                                    "M.id_marca, M.nombre_marca, PR.id_proveedor, PR.nombre_proveedor " +
                                    "FROM Productos AS P " +
                                    "JOIN Marca AS M ON P.marca_id = M.id_marca " +
                                    "JOIN Proveedores AS PR ON P.proveedor_id = PR.id_proveedor;"
                                );
                                resultSet = statement.executeQuery();
                                while (resultSet.next()) {
                            %>
                            <tr class="border-b bg-white hover:bg-orange-100" 
                                data-id="<%= resultSet.getInt("id_producto") %>"
                                data-marca-id="<%= resultSet.getInt("id_marca") %>"
                                data-descripcion="<%= resultSet.getString("descripcion") %>"
                                data-precio="<%= resultSet.getDouble("precio") %>"
                                data-cantidad="<%= resultSet.getInt("cantidad") %>"
                                data-proveedor-id="<%= resultSet.getInt("id_proveedor") %>"
                                data-imagen-url="<%= resultSet.getString("url_imagen") %>">

                                <td class="p-3"><%= resultSet.getInt("id_producto") %></td>
                                <td class="p-3"><%= resultSet.getString("nombre_marca") %></td>
                                <td class="p-3"><%= resultSet.getString("descripcion") %></td>
                                <td class="p-3">S/<%= resultSet.getDouble("precio") %></td>
                                <td class="p-3"><%= resultSet.getInt("cantidad") %></td>
                                <td class="p-3">
                                    <img src="<%= request.getContextPath() + resultSet.getString("url_imagen") %>" alt="Producto" class="w-24 h-24 object-cover rounded-full">
                                </td>
                                <td class="p-3"><%= resultSet.getString("nombre_proveedor") %></td>
                                <td class="p-3">
                                    <!-- Bot贸n para editar -->
                                    <button class="btn text-white btn-warning btn-sm mr-2 edit-btn">
                                        <i class="fi fi-rs-edit"></i>
                                    </button>

                                    <!-- Modal para editar -->
                                    <dialog id="edit_modal_<%= resultSet.getInt("id_producto") %>" class="modal">
                                        <div class="modal-box">
                                            <form method="dialog">
                                                <button class="btn btn-sm btn-circle btn-ghost absolute right-2 top-2">
                                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                                                    </svg>
                                                </button>
                                            </form>
                                            <div class="p-8 rounded-lg max-w-md w-full">
                                                <h2 class="text-2xl font-bold mb-6 text-gray-800">Editar Producto</h2>
                                                <form action="ActualizaProducto" method="post" enctype="multipart/form-data">
                                                    <input type="hidden" name="id_producto" value="<%= resultSet.getInt("id_producto") %>">
                                                    <input type="hidden" name="imagen_actual" value="">

                                                    <div class="mb-4">
                                                        <label for="marcaEdit2" class="block text-sm font-semibold mb-2">Marca</label>
                                                        <select name="marca" class="w-full px-4 py-2 border rounded-md focus:outline-none focus:border-blue-500" required>
                                                            <option value="">Seleccione una marca</option>
                                                            <% for (Marca marca : marcas) { %>
                                                            <option value="<%= marca.getIdMarca() %>"><%= marca.getNombreMarca() %></option>
                                                            <% } %>
                                                        </select>
                                                    </div>

                                                    <div class="mb-4">
                                                        <label for="descripcionEdit2" class="block text-sm font-semibold mb-2">Descripci髇</label>
                                                        <textarea name="descripcion" rows="4" class="w-full px-4 py-2 border rounded-md resize-none focus:outline-none focus:border-blue-500" placeholder="Ingrese la descripci髇" required><%= resultSet.getString("descripcion") %></textarea>
                                                    </div>

                                                    <div class="mb-4">
                                                        <label for="precioEdit2" class="block text-sm font-semibold mb-2">Precio</label>
                                                        <input type="number" name="precio" min="0" step="0.01" class="w-full px-4 py-2 border rounded-md focus:outline-none focus:border-blue-500" placeholder="Ingrese el precio" required value="<%= resultSet.getDouble("precio") %>">
                                                    </div>

                                                    <div class="mb-4">
                                                        <label for="cantidadEdit2" class="block text-sm font-semibold mb-2">Cantidad</label>
                                                        <input type="number" name="cantidad" min="0" class="w-full px-4 py-2 border rounded-md focus:outline-none focus:border-blue-500" placeholder="Ingrese la cantidad" required value="<%= resultSet.getInt("cantidad") %>">
                                                    </div>

                                                    <div class="mb-4">
                                                        <label for="proveedorEdit" class="block text-sm font-semibold mb-2">Proveedor</label>
                                                        <select name="proveedor" class="w-full px-4 py-2 border rounded-md focus:outline-none focus:border-blue-500" required>
                                                            <option value="">Seleccione un proveedor</option>
                                                            <% for (Proveedor proveedor : proveedores) { %>
                                                            <option value="<%= proveedor.getIdProveedor() %>"><%= proveedor.getNombreProveedor() %></option>
                                                            <% } %>
                                                        </select>
                                                    </div>

                                                    <div class="mb-4">
                                                        <label for="imagenEdit2" class="block text-sm font-semibold mb-2">Cargar Imagen</label>
                                                        <input type="file" name="imagen" accept="image/*" class="w-full px-4 py-2 border rounded-md focus:outline-none focus:border-blue-500">
                                                    </div>

                                                    <div class="text-right">
                                                        <button type="submit" class="text-white bg-yellow-500 text-sm font-semibold border px-4 py-2 rounded-lg hover:text-yellow-600 hover:border-yellow-600 hover:bg-white transition duration-200">Guardar Cambios</button>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                    </dialog>

                                    <!-- Bot贸n para eliminar -->
                                    <button class="btn text-white btn-error btn-sm"
                                            onclick="document.getElementById('delete_modal_<%= resultSet.getInt("id_producto") %>').showModal()">
                                        <i class="fi fi-rs-trash"></i>
                                    </button>

                                    <!-- Modal para eliminar -->
                                    <dialog id="delete_modal_<%= resultSet.getInt("id_producto") %>" class="modal">
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
                                                <h3 class="ml-6 font-bold text-lg">縀st醩 seguro de eliminar el producto <%= resultSet.getString("descripcion") %>?</h3>
                                            </div>
                                            <p class="py-4">Esta acci髇 no se puede deshacer.</p>
                                            <div class="flex justify-end">
                                                <button class="btn btn- mr-2 bg-slate-200" onclick="document.getElementById('delete_modal_<%= resultSet.getInt("id_producto") %>').close()">Cancelar</button>
                                                <form action="crudeliminarproducto.jsp" method="post">
                                                    <input type="hidden" name="id_producto" value="<%= resultSet.getInt("id_producto") %>">
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
                                if (resultSet != null) try { resultSet.close(); } catch (SQLException e) { e.printStackTrace(); }
                                if (statement != null) try { statement.close(); } catch (SQLException e) { e.printStackTrace(); }
                                if (connection != null) try { connection.close(); } catch (SQLException e) { e.printStackTrace(); }
                            }
                            %>
                        </tbody>
                    </table>
                </div>

                <script>
                    document.addEventListener('DOMContentLoaded', function () {
                        const openModalBtns = document.querySelectorAll('.openModalBtn1');
                        const modal = document.getElementById('modal1');
                        const closeModalBtn = document.getElementById('closeModalBtn1');
                        const cancelBtn = document.getElementById('cancelBtn1');
                        const descripcionSpan = document.getElementById('descripcion');
                        const idProductoInput = document.getElementById('id_producto');

                        openModalBtns.forEach(button => {
                            button.addEventListener('click', function () {
                                const descripcion = this.getAttribute('data-name-descripcion');
                                const idProducto = this.getAttribute('data-name-id');

                                descripcionSpan.textContent = descripcion;
                                idProductoInput.value = idProducto;

                                modal.classList.remove('hidden');
                            });
                        });

                        closeModalBtn.addEventListener('click', function () {
                            modal.classList.add('hidden');
                        });

                        cancelBtn.addEventListener('click', function (event) {
                            event.preventDefault();
                            modal.classList.add('hidden');
                        });
                    });

                </script>
                <script>
                    document.addEventListener('DOMContentLoaded', function () {
                        const mobileMenuButton = document.getElementById('mobileMenuButton');
                        const mobileMenu = document.getElementById('mobileMenu');


                        mobileMenuButton.addEventListener('click', function () {
                            mobileMenu.classList.toggle('hidden');
                        });
                    });
                    document.getElementById('openModalAdd').addEventListener('click', function () {
                        document.getElementById('myModalAdd').classList.remove('hidden');
                    });

                    document.getElementById('closeModalAdd').addEventListener('click', function () {
                        document.getElementById('myModalAdd').classList.add('hidden');
                    });
                </script>

                <script>
                    document.addEventListener("DOMContentLoaded", function () {
                        const editButtons = document.querySelectorAll(".edit-btn");
                        editButtons.forEach(button => {
                            button.addEventListener("click", function () {
                                const row = button.closest("tr");

                                // Extraer datos de los atributos data-
                                const id = row.dataset.id;
                                const marcaId = row.dataset.marcaId;
                                const descripcion = row.dataset.descripcion;
                                const precio = row.dataset.precio;
                                const cantidad = row.dataset.cantidad;
                                const proveedorId = row.dataset.proveedorId;
                                const imagenUrl = row.dataset.imagenUrl;

                                // Abrir el modal de edici贸n
                                const editModal = document.getElementById("edit_modal_" + id);
                                editModal.showModal();

                                // Rellenar el formulario
                                editModal.querySelector("select[name='marca']").value = marcaId;
                                editModal.querySelector("textarea[name='descripcion']").value = descripcion;
                                editModal.querySelector("input[name='precio']").value = precio;
                                editModal.querySelector("input[name='cantidad']").value = cantidad;
                                editModal.querySelector("select[name='proveedor']").value = proveedorId;
                                editModal.querySelector("input[name='imagen_actual']").value = imagenUrl;
                            });
                        });
                    });
                </script>
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
        td = tr[i].getElementsByTagName("td");
        if (td) {
            // Solo filtrar por las columnas de ID y Descripci贸n (铆ndices 0 y 2)
            for (var j = 0; j < td.length; j++) {
                if (j === 0 || j === 2) { // ID y Descripci贸n
                    txtValue = td[j].textContent || td[j].innerText;
                    if (txtValue.toUpperCase().indexOf(filter) > -1) {
                        tr[i].style.display = ""; // Mostrar la fila si coincide
                        break;
                    }
                }
            }
        }
    }
}

            </script>
                </body>
                </html>