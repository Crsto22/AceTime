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
        <title>Ventas</title>
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
                    <li class="relative flex cursor-pointer space-x-2 rounded-md py-4 px-10 bg-orange-400 text-white ">
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
                        class="relative flex cursor-pointer space-x-2 rounded-md py-4 px-10 text-gray-600 text-gray-600 hover:bg-orange-400 hover:text-white ">
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

                <div class="overflow-x-auto mt-14">
                    <div class="flex justify-end mb-4">
                        <label class="input input-bordered flex items-center gap-2">
                            <input type="text" id="searchInput" class="grow" placeholder="Buscar por cliente" onkeyup="filterTable()" />
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" fill="currentColor" class="w-4 h-4 opacity-70">
                            <path fill-rule="evenodd" d="M9.965 11.026a5 5 0 1 1 1.06-1.06l2.755 2.754a.75.75 0 1 1-1.06 1.06l-2.755-2.754ZM10.5 7a3.5 3.5 0 1 1-7 0 3.5 3.5 0 0 1 7 0Z" clip-rule="evenodd" />
                            </svg>
                        </label>
                    </div>

                    <table id="purchaseTable" class="min-w-full bg-white">
                        <thead>
                            <tr>
                                <th class="py-2 px-4 border-b text-left text-gray-600">ID</th>
                                <th class="py-2 px-4 border-b text-left text-gray-600">Cliente</th>
                                <th class="py-2 px-4 border-b text-left text-gray-600">Número de DNI</th>
                                <th class="py-2 px-4 border-b text-left text-gray-600">Total de la Compra</th>
                                <th class="py-2 px-4 border-b text-center text-gray-600">Comprobante</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                Connection conn1 = null;
                                PreparedStatement pstmt1 = null;
                                ResultSet rs1 = null;

                                try {
                                    Mantenimiento mantenimiento1 = new Mantenimiento();
                                    mantenimiento1.conectarBD();
                                    conn1 = mantenimiento1.getConexion();

                                    String sql = "SELECT " +
                                        "dc.id_compra, " +
                                        "dc.id_comprador, " +
                                        "c.nombre AS nombre_comprador, " +
                                        "c.apellido AS apellido_comprador, " +
                                        "c.Num_Documento AS num_doc_comprador, " +
                                        "c.correo AS correo_comprador, " +
                                        "dc.id_usuario, " +
                                        "u.nombre AS nombre_cliente, " +
                                        "u.apellido AS apellido_cliente, " +
                                        "u.Num_Documento AS num_doc_cliente, " +
                                        "u.correo AS correo_cliente, " +
                                        "dc.total_compra, " +
                                        "dc.fecha_compra " +
                                        "FROM Detalle_Compra dc " +
                                        "LEFT JOIN Datos_comprador c ON dc.id_comprador = c.id_comprador " +
                                        "LEFT JOIN Usuarios u ON dc.id_usuario = u.id_usuario";

                                    pstmt1 = conn1.prepareStatement(sql);
                                    rs1 = pstmt1.executeQuery();

                                    boolean hayCompras = false;
                                    while (rs1.next()) {
                                        hayCompras = true;
                                        int idCompra = rs1.getInt("id_compra");
                                        
                                        String nombre_comprador = rs1.getString("nombre_comprador");
                                        String apellido_comprador = rs1.getString("apellido_comprador");
                                        String num_doc_comprador = rs1.getString("num_doc_comprador");
                                        String id_comprador =rs1.getString("id_comprador");
                                        
                                        
                                        String nombre_cliente = rs1.getString("nombre_cliente");
                                        String apellido_cliente = rs1.getString("apellido_cliente");
                                        String num_doc_cliente = rs1.getString("num_doc_cliente");
                                        String id_usuario =rs1.getString("id_usuario");
                                        
                                        String fecha_compra =rs1.getString("fecha_compra" );
                                        double totalCompra = rs1.getDouble("total_compra");

                                        if (id_usuario == null) {
                            %>
                            <tr class="bg-gray-50">
                                <td class="py-2 px-4 border-b"><%= idCompra %></td>
                                <td class="py-2 px-4 border-b"><%= nombre_comprador + " " + apellido_comprador %></td>
                                <td class="py-2 px-4 border-b"><%= num_doc_comprador %></td>
                                <td class="py-2 px-4 border-b">S/<%= totalCompra %></td>
                                <td class="py-2 px-4 border-b text-center">
                                    <button class="px-6 py-2 bg-red-500 text-white rounded hover:bg-red-600" 
                                            onclick="window.open('factura.jsp?id_compra=<%=idCompra %>&id_comprador=<%=id_comprador %>&fecha_comprobante=<%=fecha_compra%>','_blank', 'width=700,height=900');">
                                        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 inline-block" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.522 5 12 5s8.268 2.943 9.542 7c-1.274 4.057-5.064 7-9.542 7s-8.268-2.943-9.542-7z" />
                                        </svg>
                                    </button>
                                </td>
                            </tr>
                            <%
                                        } else {
                            %>
                            <tr class="bg-gray-50">
                                <td class="py-2 px-4 border-b"><%= idCompra %></td>
                                <td class="py-2 px-4 border-b"><%= nombre_cliente + " " + apellido_cliente %></td>
                                <td class="py-2 px-4 border-b"><%= num_doc_cliente %></td>
                                <td class="py-2 px-4 border-b">S/<%= totalCompra %></td>
                                <td class="py-2 px-4 border-b text-center">
                                    <button class="px-6 py-2 bg-red-500 text-white rounded hover:bg-red-600" onclick="window.open('factura.jsp?id_compra=<%=idCompra %>&id_usuario=<%=id_usuario %>&fecha_comprobante=<%=fecha_compra%>', 
    '_blank', 'width=700,height=900');">
                                        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 inline-block" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.522 5 12 5s8.268 2.943 9.542 7c-1.274 4.057-5.064 7-9.542 7s-8.268-2.943-9.542-7z" />
                                        </svg>
                                    </button>
                                </td>
                            </tr>
                            <%
                                        }
                                    }
                                    if (!hayCompras) {
                            %>
                            <tr>
                                <td colspan="5" class="py-4 px-4 text-center text-gray-600">No hay últimas compras realizadas.</td>
                            </tr>
                            <%
                                    }
                                } catch (Exception e) {
                                    out.println("Error al conectar a la base de datos: " + e.getMessage());
                                    e.printStackTrace();
                                } finally {
                                    if (rs1 != null) try { rs1.close(); } catch (SQLException e) { e.printStackTrace(); }
                                    if (pstmt1 != null) try { pstmt1.close(); } catch (SQLException e) { e.printStackTrace(); }
                                    if (conn1 != null) try { conn1.close(); } catch (SQLException e) { e.printStackTrace(); }
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
   <script src="js/busquedaventas.js" ></script>
   <script src="js/sidebar.js"></script>
    </body>
</html>