<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page import="datos.Mantenimiento, java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException" %>
<%@ page import="java.sql.SQLException" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Datos</title>
        <link href="./output.css" rel="stylesheet" />
        <link rel="stylesheet"
              href="https://cdn-uicons.flaticon.com/2.3.0/uicons-regular-rounded/css/uicons-regular-rounded.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <link href="./output.css" rel="stylesheet">
        <script src="https://cdn.tailwindcss.com"></script>
        <link
            rel="stylesheet"
            href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"
            />
    </head>
   <% 
    String totalCarrito = request.getParameter("totalCarrito");
    Integer idUsuario = (Integer) session.getAttribute("idUsuario");
    String sesion_id = request.getParameter("sesion_id");
    String correo = "", nombre = "", apellido = "", telefono = "", tipoDocumento = "", numDocumento = "";
    boolean isUserLoggedIn = idUsuario != null;

    if (isUserLoggedIn) {
        Mantenimiento mantenimiento = new Mantenimiento();
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;
        try {
            // Establecer la conexión a la base de datos utilizando el método conectarBD
            mantenimiento.conectarBD();
            connection = mantenimiento.getConexion();

            String query = "SELECT correo, nombre, apellido, telefono_movil, tipo_documento_id, Num_Documento FROM Usuarios WHERE id_usuario = ?";
            statement = connection.prepareStatement(query);
            statement.setInt(1, idUsuario);
            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                correo = resultSet.getString("correo");
                nombre = resultSet.getString("nombre");
                apellido = resultSet.getString("apellido");
                telefono = resultSet.getString("telefono_movil");
                tipoDocumento = resultSet.getString("tipo_documento_id");
                numDocumento = resultSet.getString("Num_Documento");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // Cerrar recursos en el bloque finally
            try {
                if (resultSet != null) resultSet.close();
                if (statement != null) statement.close();
                mantenimiento.cerrarBD();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
%>

    <body class="bg-slate-50">
        <nav class="bg-gray-100 fixed top-0 left-0 w-full z-10 ">
            <div class="bg-gray-100 font-sans w-full min-h-0 m-0">
                <div class="bg-gray-100">
                    <div class="container mx-auto px-0">
                        <div class="flex items-center justify-between py-4">
                            <!-- Imagen de logo -->
                            <div class="flex items-center ml-2">
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
                            <!-- Opciones -->
                            <div class="hidden sm:flex sm:items-center" id="signInUp">
                               <div class="flex justify-between items-center pt-2">
                                    <a href="productos.jsp" class="flex items-center text-white bg-black text-sm font-semibold border px-4 py-2 rounded-lg hover:text-yellow-600 hover:border-yellow-600 hover:bg-white">
                                        <i class="fi fi-rr-arrow-small-left text-xl mr-2"></i> Seguir Comprando
                                    </a>
                                </div>
                            </div>
                            <!-- Icono de ajustes cuando es responsive -->
                            <div class="sm:hidden cursor-pointer" id="mobileMenuButton">
                                <i class="fi fi-rr-menu-burger text-4xl mx-6" >  </i>
                            </div>
                        </div>
                        <!-- Opciones cuando es responsive -->
                        <div class=" sm:hidden bg-white border-t-2 py-2 hidden" id="mobileMenu">
                            <div class="flex flex-col">
                                <a href="index.jsp"
                                   class="text-gray-800 text-base font-semibold hover:text-yellow-600 mb-1 mx-5"">Inicio</a>
                                <a href="productos.jsp"
                                   class="text-gray-800 text-base font-semibold hover:text-yellow-600 mb-1 mx-5"> Productos</a>
                                <a href="nosotros.jsp"
                                   class="text-gray-800 text-base font-semibold hover:text-yellow-600 mb-1 mx-5"> Nosotros</a>
                                <a href="contactos.jsp"
                                   class="text-gray-800 text-base font-semibold hover:text-yellow-600 mb-1 mx-5"> Contactos</a>
                                <div class="flex justify-between items-center pt-2">
                                    <a href="productos.jsp" class="flex items-center text-white bg-black text-sm font-semibold border px-4 py-2 rounded-lg hover:text-yellow-600 hover:border-yellow-600 hover:bg-white">
                                        <i class="fi fi-rr-arrow-small-left text-xl mr-2"></i> Seguir Comprando
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </nav>
        <div class="flex flex-row space-x-2 mt-28 mx-6">
            <div class="w-full text-center"><i class="fi fi-rr-shopping-cart text-2xl text-yellow-600"></i></div>
            <div class="w-full text-center"><i class="fi fi-rr-ballot-check text-2xl text-yellow-600"></i></div>
            <div class="w-full text-center "><i class="fi fi-rr-credit-card text-2xl text-gray-400  "></i></div>
        </div>
        <div class="flex flex-row space-x-2 mt-2 mx-6">
            <div class="h-1.5 w-full bg-gray-700 text-center"></div>
            <div class="h-1.5 w-full bg-gray-700 text-center animate__animated animate__lightSpeedInLeft"></div>
            <div class="h-1.5 w-full bg-gray-200 text-center"></div>
        </div>
        <div class="flex flex-row space-x-2 mx-6">
            <div class="w-full text-center">1. Carrito de compras</div>
            <div class="w-full text-center">2. Datos personales</div>
            <div class="w-full text-center text-gray-400">3. Método de Pago</div>
        </div>


        <div class="flex flex-col sm:flex-row  justify-between gap-6 mx-5 sm:mx-2 md:mx-20 mt-12 mb-12">
            <div class="container mx-auto">
                <form action="pago.jsp" method="post" class="bg-zinc-100 shadow-lg rounded-lg overflow-hidden p-6">
                    <%
                        if (isUserLoggedIn) {
                    %>
                    <input type="hidden" name="id_usuario" value="<%= idUsuario %>">
                    <%
                        } else {
                    %>
                    <input type="hidden" name="sesion_id" value="<%= sesion_id %>">
                    <%
                        }
                    %>
                    <input type="hidden" name="totalCarrito" value="<%= totalCarrito %>" required>
                    <p class="text-start text-lg font-bold mb-4">Datos Personales</p>
                    <hr class="my-4 border-black">

                    <div class="mb-4">
                        <label class="block text-sm mb-2" for="correo">Solicitamos únicamente lo esencial para la finalización de la compra</label>
                        <label class="block text-sm font-bold mb-2" for="correo">Correo</label>
                        <input class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:border-indigo-500"
                               type="email" id="correo" name="correo" placeholder="Correo" required value="<%= correo %>" <%= isUserLoggedIn ? "readonly" : "" %> >
                    </div>

                    <div class="flex flex-wrap -mx-2 mb-4">
                        <div class="w-1/2 px-2">
                            <label class="block text-sm font-bold mb-2" for="nombre">Nombre</label>
                            <input class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:border-indigo-500"
                                   type="text" id="nombre" name="nombre" placeholder="Nombre" required value="<%= nombre %>" <%= isUserLoggedIn ? "readonly" : "" %> >
                        </div>
                        <div class="w-1/2 px-2">
                            <label class="block text-sm font-bold mb-2" for="apellido">Apellido</label>
                            <input class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:border-indigo-500"
                                   type="text" id="apellido" name="apellido" placeholder="Apellido" required value="<%= apellido %>" <%= isUserLoggedIn ? "readonly" : "" %> >
                        </div>
                    </div>

                    <div class="mb-4">
                        <label class="block text-sm font-bold mb-2" for="telefono">Teléfono/móvil</label>
                        <input class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:border-indigo-500"
                               type="tel" id="telefono" name="telefono" placeholder="Teléfono/móvil" pattern="^[0-9]{9}$" maxlength="9" required value="<%= telefono %>" <%= isUserLoggedIn ? "readonly" : "" %> >
                    </div>

                    <div class="flex flex-wrap -mx-2 mb-4">
                        <div class="w-1/2 px-2">
                            <label class="block text-sm font-bold mb-2" for="tipo_documento">Tipo de Documento</label>
                            <select class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:border-indigo-500"
                                    id="tipo_documento" name="tipo_documento" required <%= isUserLoggedIn ? "disabled" : "" %> >
                                <option value="1" <%= tipoDocumento.equals("1") ? "selected" : "" %> >DNI</option>
                                <option value="2" <%= tipoDocumento.equals("2") ? "selected" : "" %> >Carnet Extranjeria</option>
                                <option value="3" <%= tipoDocumento.equals("3") ? "selected" : "" %> >Pasaporte</option>
                            </select>
                        </div>
                        <div class="w-1/2 px-2">
                            <label class="block text-sm font-bold mb-2" for="documento">Documento</label>
                            <input type="text" id="documento" name="documento" placeholder="Documento" class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:border-indigo-500" required pattern="^[0-9]{8}$" maxlength="8" value="<%= numDocumento %>" <%= isUserLoggedIn ? "readonly" : "" %> >
                        </div>
                    </div>
                    <%
                                            if (isUserLoggedIn) {
                    %>
                    <div class="flex justify-center">
                        <a href="AjustesUsuario.jsp" class="text-indigo-600 hover:underline mb-2">¿Quieres editar tus datos? Haz clic aquí</a>
                    </div>
                    <%
                        }
                    %>
                    <div class="flex justify-center mb-4">
                        <button class="bg-yellow-700 text-white font-bold py-2 px-4 rounded border border-transparent hover:border-yellow-600 hover:bg-white hover:text-yellow-700 focus:outline-none focus:shadow-outline"
                                type="submit" required>Continuar</button>
                    </div>


                </form>
            </div>

            <div class="w-full sm:w-1/2 h-min bg-zinc-100 shadow-lg rounded-lg overflow-hidden p-6 justify-center">
                <p class="text-center text-lg font-bold mb-4">Resumen de la compra</p>
                <div class="flex flex-col justify-center items-center space-y-3 overflow-auto max-h-80 ">
                    <div class="mt-28">
                    </div>
                    <%
    Mantenimiento mantenimiento = new Mantenimiento();
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        // Establecer la conexión a la base de datos utilizando el método conectarBD
        mantenimiento.conectarBD();
        conn = mantenimiento.getConexion();

        // Consulta SQL para obtener los detalles de la compra
        String query;
        if (session.getAttribute("idUsuario") != null) {
            // Si hay un idUsuario en la sesión, usar id_usuario para la consulta
            query = "SELECT p.descripcion, p.url_imagen, c.cantidad, p.precio FROM carrito c INNER JOIN Productos p ON c.id_producto = p.id_producto WHERE c.id_usuario = ? ORDER BY c.id_carrito";
            pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, (Integer) session.getAttribute("idUsuario"));
        } else {
            // Si no hay idUsuario en la sesión, usar sesion_id para la consulta
            query = "SELECT p.descripcion, p.url_imagen, c.cantidad, p.precio FROM carrito c INNER JOIN Productos p ON c.id_producto = p.id_producto WHERE c.sesion_id = ? ORDER BY c.id_carrito";
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, sesion_id);
        }
        
        rs = pstmt.executeQuery();

        // Mostrar los detalles de la compra en el HTML
        while (rs.next()) {
            String descripcion = rs.getString("descripcion");
            String url_imagen = rs.getString("url_imagen");
            int cantidad = rs.getInt("cantidad");
            double precio = rs.getDouble("precio");
                    %>
                    <div class="w-full md:w-1/2 lg:w-1/4 h-auto mb-4">
                        <div class="sm:mx-1 md:mx-4 mx-5"> 
                            <img src="${pageContext.request.contextPath}<%= url_imagen %>" alt="<%= descripcion %>" class="w-full h-auto object-cover" />    
                        </div>
                    </div>
                    <div class="w-full h-20">
                        <div class="justify-center items-center">
                            <p class="font-semibold text-center"><%= descripcion %></p>
                            <p class="text-sm text-center">Cantidad <%= cantidad %></p>
                        </div>  
                    </div>
                    <%
                            }
                        } catch (Exception e) {
                            out.println("Error al obtener los detalles de la compra: " + e.getMessage());
                        } finally {
                            // Cerrar recursos en el bloque finally
                            try { if (rs != null) rs.close(); } catch (Exception e) { /* Manejo de errores */ }
                            try { if (pstmt != null) pstmt.close(); } catch (Exception e) { /* Manejo de errores */ }
                            mantenimiento.cerrarBD();
                        }
                    %>
                </div>
                <hr class="my-4">
                <div class="flex justify-between items-center mb-4">
                    <span class="text-gray-700">Total</span>
                    <span class="text-yellow-600 font-semibold">s/<%= totalCarrito %></span>
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
        <script src="js/navbar.js"></script>
    </body>

</html>