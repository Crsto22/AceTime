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
        <title>Dashboard</title>
        <link href="./output.css" rel="stylesheet" />
        <link href="https://cdn.jsdelivr.net/npm/daisyui@4.12.2/dist/full.min.css" rel="stylesheet" type="text/css" />
        <script src="https://cdn.tailwindcss.com"></script>
        <link rel='stylesheet' href='https://cdn-uicons.flaticon.com/2.4.0/uicons-solid-rounded/css/uicons-solid-rounded.css'>
        <link rel='stylesheet'
              href='https://cdn-uicons.flaticon.com/2.4.0/uicons-regular-straight/css/uicons-regular-straight.css'>
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
                <div class="flex-1 overflow-x-auto">
                    <ul class="mt-10 space-y-3 min-w-[300px] md:min-w-0">
                        <li
                            class="relative flex cursor-pointer space-x-2 rounded-md py-4 px-10 bg-orange-400 text-white">
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
                            class="relative flex cursor-pointer space-x-2 rounded-md py-4 px-10 text-gray-600 hover:bg-orange-400 hover:text-white"
                            onclick="window.location.href = 'panelproductos.jsp'">
                            <i class="fi fi-rs-box-open-full text-xl"></i>
                            <span>Productos</span>
                        </li>
                        <li onclick="window.location.href = 'panelventas.jsp'" class="relative flex cursor-pointer space-x-2 rounded-md py-4 px-10 text-gray-600 hover:bg-orange-400 hover:text-white ">
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
            </div>

            <div id="main-content" class="md:ml-72 p-8">
                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 mt-14">
                    <div class="flex items-stretch md:h-40  bg-white border border-gray-200 rounded-lg shadow-lg overflow-hidden">
                        <div class="flex items-center justify-center w-1/3 bg-green-400 text-white">
                            <i class="fi fi-sr-point-of-sale-bill text-5xl"></i>
                        </div>
                        <div class="flex-1 p-4 flex flex-col justify-center text-center">
                            <div> 
                                <%
         Connection conexion = null;
         try {
             Mantenimiento mantenimiento = new Mantenimiento();
             mantenimiento.conectarBD();
             conexion = mantenimiento.getConexion();
             String consulta = "SELECT COUNT(*) AS total FROM Detalle_Compra";
             PreparedStatement pstmt = conexion.prepareStatement(consulta);
             ResultSet rs = pstmt.executeQuery();
             int total = 0; 
             if (rs.next()) { 
                 total = rs.getInt("total"); 
             }
                                %>
                                <div class="font-bold text-3xl"><%= total %></div>
                                <div class="stat-title">Ventas Totales</div>
                                <%
        rs.close();
        pstmt.close();
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        if (conexion != null) {
            try {
                conexion.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
                                %>
                            </div>
                        </div>
                    </div>
                    <div class="flex items-stretch md:h-40  bg-white border border-gray-200 rounded-lg shadow-lg overflow-hidden">
                        <div class="flex items-center justify-center w-1/3 bg-yellow-400 text-white">
                            <i class="fi fi-sr-sack-dollar text-5xl"></i>
                        </div>
                        <div class="flex-1 p-4 flex flex-col justify-center text-center">
                            <div>
                                <%
                                    Connection conexion1 = null;
                                    try {
                                        Mantenimiento mantenimiento1 = new Mantenimiento();
                                        mantenimiento1.conectarBD();
                                        conexion1 = mantenimiento1.getConexion();
                                        String consulta1 = "SELECT SUM(total_compra) AS total_suma FROM Detalle_Compra";
                                        PreparedStatement pstmt1 = conexion1.prepareStatement(consulta1);
                                        ResultSet rs1 = pstmt1.executeQuery();
                                        double total_suma = 0; 
                                        if (rs1.next()) { 
                                            total_suma = rs1.getDouble("total_suma"); 
                                        }
                                %>
                                <div class="font-bold text-3xl">S/<%= total_suma  %></div>
                                <div class="stat-title">Ingresos Totales</div>
                                <%
                                        rs1.close();
                                        pstmt1.close();
                                    } catch (SQLException e) {
                                        e.printStackTrace();
                                    } finally {
                                        if (conexion1 != null) {
                                            try {
                                                conexion1.close();
                                            } catch (SQLException e) {
                                                e.printStackTrace();
                                            }
                                        }
                                    }
                                %>
                            </div>
                        </div>
                    </div> 
                    <div class="flex items-stretch md:h-40  bg-white border border-gray-200 rounded-lg shadow-lg overflow-hidden">
                        <div class="flex items-center justify-center w-1/3 bg-red-400 text-white">
                            <i class="fi fi-sr-user text-5xl"></i>
                        </div>
                        <div class="flex-1 p-4 flex flex-col justify-center text-center">
                            <div>
                                <%
    Connection conexion2 = null;
    try {
        Mantenimiento mantenimiento2 = new Mantenimiento();
        mantenimiento2.conectarBD();
        conexion2 = mantenimiento2.getConexion();
        String consulta2 = "SELECT COUNT(*) AS total_usuarios FROM Usuarios";
        PreparedStatement pstmt2 = conexion2.prepareStatement(consulta2);
        ResultSet rs2 = pstmt2.executeQuery();
        int total_usuarios = 0; 
        if (rs2.next()) { 
            total_usuarios = rs2.getInt("total_usuarios"); 
        }
                                %>
                                <div class="font-bold text-3xl"><%= total_usuarios %></div>
                                <div class="stat-title">Nuevos Usuarios</div>
                                <%
                                        rs2.close();
                                        pstmt2.close();
                                    } catch (SQLException e) {
                                        e.printStackTrace();
                                    } finally {
                                        if (conexion2 != null) {
                                            try {
                                                conexion2.close();
                                            } catch (SQLException e) {
                                                e.printStackTrace();
                                            }
                                        }
                                    }
                                %>

                            </div>
                        </div>
                    </div>
                    <div class="flex items-stretch md:h-40  bg-white border border-gray-200 rounded-lg shadow-lg overflow-hidden">
                        <div class="flex items-center justify-center w-1/3 bg-blue-400 text-white">
                            <i class="fi fi-sr-shopping-cart-check text-5xl"></i>
                        </div>
                        <div class="flex-1 p-4 flex flex-col justify-center text-center">
                            <div>
                                <%
    Connection conexion3 = null;
    try {
        Mantenimiento mantenimiento3 = new Mantenimiento();
        mantenimiento3.conectarBD();
        conexion3 = mantenimiento3.getConexion();
        String consulta3 = "SELECT SUM(cantidad) AS total_cantidad FROM Comprobante";
        PreparedStatement pstmt3 = conexion3.prepareStatement(consulta3);
        ResultSet rs3 = pstmt3.executeQuery();
        int total_cantidad  = 0; 
        if (rs3.next()) { 
            total_cantidad  = rs3.getInt("total_cantidad"); 
        }
                                %>
                                <div class="font-bold text-3xl"><%= total_cantidad %></div>
                                <div class="stat-title">Productos Vendidos</div>
                                <%
                                        rs3.close();
                                        pstmt3.close();
                                    } catch (SQLException e) {
                                        e.printStackTrace();
                                    } finally {
                                        if (conexion3 != null) {
                                            try {
                                                conexion3.close();
                                            } catch (SQLException e) {
                                                e.printStackTrace();
                                            }
                                        }
                                    }
                                %>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="container mx-auto mt-10 grid grid-cols-1 md:grid-cols-2 gap-4">
                    <!-- Contenedor de la Lista de Productos -->
                    <div class="bg-white p-6 rounded-lg shadow-md">
                        <h2 class="text-lg stat-value mb-4">Lista de Productos</h2>
                        <div class="overflow-y-auto max-h-96">
                            <ul class="divide-y divide-gray-300">
                                <%
   try {
       Mantenimiento mantenimiento4 = new Mantenimiento();
       mantenimiento4.conectarBD();
       Connection connection4 = mantenimiento4.getConexion();

       PreparedStatement statement4 = connection4.prepareStatement("SELECT * FROM Productos");
       ResultSet resultSet4 = statement4.executeQuery();
       while (resultSet4.next()) {
                                %>
                                <li class="flex justify-between items-center py-2">
                                    <span class="text-lg "><%= resultSet4.getString("descripcion") %></span>
                                    <span class="text-lg font-bold"><%= resultSet4.getInt("cantidad") %> unidades</span>
                                    <span class="text-lg font-bold">S/<%= resultSet4.getDouble("precio") %></span>
                                </li>
                                <%
                                        }
                                        resultSet4.close();
                                        statement4.close();
                                        mantenimiento4.cerrarBD();
                                    } catch (SQLException e) {
                                        e.printStackTrace();
                                    }
                                %>
                            </ul>
                        </div>
                        <div class="mt-6">
                            <button onclick="window.location.href = 'panelproductos.jsp'" class="bg-orange-400 hover:bg-orange-600 text-white font-bold py-2 px-4 rounded">
                                Administrar Productos
                            </button>
                        </div>
                    </div>
                    <div class="bg-white p-6 rounded-lg shadow-md">
                        <h2 class="text-lg stat-value mb-4 ">Últimas Ventas</h2>
                        <div class="overflow-y-auto max-h-96">
                            <ul class="divide-y divide-gray-300">
                                <%
   try {
       Mantenimiento mantenimiento5 = new Mantenimiento();
       mantenimiento5.conectarBD();
       Connection connection5 = mantenimiento5.getConexion();

       PreparedStatement statement5 = connection5.prepareStatement("SELECT * FROM Detalle_Compra ORDER BY fecha_compra DESC");
       ResultSet resultSet5 = statement5.executeQuery();
       while (resultSet5.next()) {
                                %>
                                <li class="flex justify-between items-center py-2">
                                    <span class="text-lg">Venta 00<%= resultSet5.getString("id_compra") %></span>
                                    <span class="text-lg"><%= resultSet5.getString("fecha_compra") %></span>
                                    <span class="text-lg font-bold">S/<%= resultSet5.getDouble("total_compra") %></span>
                                </li>
                                <%
                                        }
                                        resultSet5.close();
                                        statement5.close();
                                        mantenimiento5.cerrarBD();
                                    } catch (SQLException e) {
                                        e.printStackTrace();
                                    }
                                %>

                            </ul>
                        </div>
                        <div class="mt-6">
                            <button onclick="window.location.href = 'panelventas.jsp'" class="bg-red-500 hover:bg-red-600 text-white font-bold py-2 px-4 rounded">
                                Gestionar Ventas
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <script src="js/sidebar.js"></script>
    </body>
</html>