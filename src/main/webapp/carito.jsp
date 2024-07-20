<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="datos.Mantenimiento" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Carito</title>
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
            <div class="w-full text-center"><i class="fi fi-rr-ballot-check text-2xl text-gray-400"></i></div>
            <div class="w-full text-center "><i class="fi fi-rr-credit-card text-2xl text-gray-400  "></i></div>
        </div>
        <div class="flex flex-row space-x-2 mt-2 mx-6 ">
            <div class="h-1.5 w-full bg-gray-700 text-center animate__animated animate__lightSpeedInLeft" ></div>
            <div class="h-1.5 w-full bg-gray-200 text-center"></div>
            <div class="h-1.5 w-full bg-gray-200 text-center"></div>
        </div>
        <div class="flex flex-row space-x-2 mx-6">
            <div class="w-full text-center">1. Carrito de compras</div>
            <div class="w-full text-center text-gray-400">2. Datos personales</div>
            <div class="w-full text-center text-gray-400">3. Método de Pago</div>
        </div>
        <div class="container mx-auto px-max py-8">
            <div class="grid grid-cols- md:grid-cols-2 gap-8">
                <%
                    String mensaje = "";

                    // Obtener el idUsuario de la sesión
                    Integer idUsuario = (Integer) session.getAttribute("idUsuario");
                    String sesion_id = "";

                    // Obtener la ID de sesión desde la cookie o generar una nueva si no existe
                    if (idUsuario == null) {
                        Cookie[] cookies = request.getCookies();
                        if (cookies != null) {
                            for (Cookie cookie : cookies) {
                                if ("sesion_id".equals(cookie.getName())) {
                                    sesion_id = cookie.getValue();
                                    break;
                                }
                            }
                        }
                        if (sesion_id.isEmpty()) {
                            sesion_id = UUID.randomUUID().toString();
                            Cookie sesionCookie = new Cookie("sesion_id", sesion_id);
                            sesionCookie.setPath("/");
                            response.addCookie(sesionCookie);
                        }
                    }

                    Mantenimiento mantenimiento = new Mantenimiento();
                    mantenimiento.conectarBD();
                    Connection conn = mantenimiento.getConexion();

                    PreparedStatement pstmt = null;
                    ResultSet rs = null;

                    try {
                        String deleteQuery = "DELETE FROM carrito WHERE id_producto IN (SELECT id_producto FROM Productos WHERE cantidad = 0)";
                        PreparedStatement deleteStmt = conn.prepareStatement(deleteQuery);
                        deleteStmt.executeUpdate();

                        String query;
                        if (idUsuario != null) {
                            query = "SELECT p.id_producto, m.nombre_marca, p.precio, p.descripcion, c.cantidad, p.url_imagen FROM Productos p INNER JOIN Marca m ON p.marca_id = m.id_marca INNER JOIN carrito c ON p.id_producto = c.id_producto WHERE c.id_usuario = ?;";
                            pstmt = conn.prepareStatement(query);
                            pstmt.setInt(1, idUsuario);
                        } else {
                            query = "SELECT p.id_producto, m.nombre_marca, p.precio, p.descripcion, c.cantidad, p.url_imagen FROM Productos p INNER JOIN Marca m ON p.marca_id = m.id_marca INNER JOIN carrito c ON p.id_producto = c.id_producto WHERE c.sesion_id = ?";
                            pstmt = conn.prepareStatement(query);
                            pstmt.setString(1, sesion_id);
                        }

                        rs = pstmt.executeQuery();

                        if (rs != null) {
                            double totalCarrito = 0.0;
                            boolean hasProducts = false;
                %>
                <div class="bg-white shadow-lg rounded-lg overflow-hidden p-10 justify-center">
                    <div class="overflow-x-auto">
                        <table class="w-full">
                            <thead>
                                <tr>
                                    <th class="px-4 py-2">Producto</th>
                                    <th class="px-4 py-2">Precio</th>
                                    <th class="px-4 py-2">Cantidad</th>
                                    <th class="px-4 py-2">Total</th>
                                    <th class="px-4 py-2">Acción</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    while (rs.next()) {
                                        int producto_id = rs.getInt("id_producto");
                                        String marca_producto = rs.getString("nombre_marca");
                                        double precio = rs.getDouble("precio");
                                        String descripcion = rs.getString("descripcion");
                                        int cantidad = rs.getInt("cantidad");
                                        String url_imagen = rs.getString("url_imagen");
                                        double totalProducto = precio * cantidad;
                                        totalCarrito += totalProducto;
                                        hasProducts = true;
                                %>
                                <tr>
                            <form action="eliminarproducto.jsp" method="post">
                                <input type="hidden" name="id_producto" value="<%= producto_id%>">
                                <%
                                    if (idUsuario != null) {
                                %>
                                <input type="hidden" name="id_usuario" value="<%= idUsuario%>">
                                <%
                                } else {
                                %>
                                <input type="hidden" name="sesion_id" value="<%= sesion_id%>">
                                <%
                                    }
                                %>
                                <td class="px-4 py-2">
                                    <div class="flex flex-col items-center">
                                        <img src="${pageContext.request.contextPath}<%= url_imagen%>" alt="<%= marca_producto%>" class="w-16 h-16 mx-auto">
                                        <span class="mt-2 text-xs"><%= descripcion%></span>
                                    </div>
                                </td>
                                <td class="px-4 py-2">S/<%= precio%></td>
                                <td class="px-4 py-2"><%= cantidad%></td>
                                <td class="px-4 py-2 text-yellow-500 font-bold">S/<%= totalProducto%></td>
                                <td class="px-4 py-2"><button type="submit" class="text-red-500 hover:underline">Eliminar</button></td>
                            </form>
                            </tr>
                            <%
                                }
                                if (!hasProducts) {
                            %>
                            <tr>
                                <td colspan="5" class="px-4 py-2 text-center">No hay productos en el carrito. <a href="productos.jsp" class="text-blue-500 hover:underline">Agrega más productos</a></td>
                            </tr>
                            <%
                                }
                            %>
                            </tbody>
                        </table>
                    </div>
                    <div class="text-right mt-4">
                        <span class="font-bold">Total Carrito: S/<%= totalCarrito%></span>
                    </div>
                </div>
                <form action="datospersonales.jsp" method="post">
                    <div class="bg-white shadow-lg rounded-lg overflow-hidden p-6 justify-center">
                        <input type="hidden" name="totalCarrito" value="<%= totalCarrito%>">
                        <%
                            if (idUsuario != null) {
                        %>
                        <input type="hidden" name="id_usuario" value="<%= idUsuario%>">
                        <%
                        } else {
                        %>
                        <input type="hidden" name="sesion_id" value="<%= sesion_id%>">
                        <%
                            }
                        %>
                        <p class="text-center text-lg font-semibold mb-4">Comprar ahora</p>
                        <div class="flex justify-between items-center mb-4">
                            <span class="text-gray-700">Subtotal</span>
                            <span class="text-gray-800 font-semibold">S/<%= totalCarrito%></span>
                        </div>
                        <hr class="my-4">
                        <div class="flex justify-between items-center mb-4">
                            <span class="text-gray-700">Total</span>
                            <span class="text-yellow-600 font-semibold ">S/<%= totalCarrito%></span>
                        </div>
                        <div class="flex justify-center mt-40">
                            <button id="comprarBtn" type="submit" class="bg-yellow-500 hover:bg-yellow-600 text-white font-semibold py-2 px-4 rounded-lg">Ir a Comprar</button>
                        </div>
                    </div>
                </form>
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
        <script src="js/ValidacionSesion.js"></script>
        <script>

            window.onload = function () {
                var totalCarrito = <%= totalCarrito%>;
                var comprarBtn = document.getElementById("comprarBtn");

                if (totalCarrito <= 0) {
                    comprarBtn.style.display = "none";
                } else {
                    comprarBtn.style.display = "block";
                }
            };
        </script>
        <%
                } else {
                    out.println("No se encontraron productos en el carrito.");
                }
            } catch (SQLException e) {
                e.printStackTrace();
                out.println("Error al procesar la solicitud: " + e.getMessage());
            } finally {
                try {
                    if (rs != null) {
                        rs.close();
                    }
                    if (pstmt != null) {
                        pstmt.close();
                    }
                    mantenimiento.cerrarBD();
                } catch (SQLException e) {
                    e.printStackTrace();
                    out.println("Error al cerrar la conexión: " + e.getMessage());
                }
            }
        %>
    </body>
</html>