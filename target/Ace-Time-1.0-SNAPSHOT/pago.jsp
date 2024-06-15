<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet" %>
<%@ page import="java.util.regex.Pattern" %>
<%@ page import="java.util.StringTokenizer" %>
<%@ page import="java.lang.StringBuilder" %>
<%@ page import="datos.Mantenimiento" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>

<%! 
   
    public String normalizeAndCapitalize(String input) {
        if (input == null || input.isEmpty()) {
            return input;
        }

        
        input = input.trim().replaceAll("\\s+", " ");

       
        StringTokenizer tokenizer = new StringTokenizer(input, " ");
        StringBuilder result = new StringBuilder();

        while (tokenizer.hasMoreTokens()) {
            String word = tokenizer.nextToken();
            result.append(Character.toUpperCase(word.charAt(0)))
                  .append(word.substring(1).toLowerCase())
                  .append(" ");
        }

       
        return result.toString().trim();
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Metodo de Pago</title>
        <link href="./output.css" rel="stylesheet" />
        <link rel="stylesheet"
              href="https://cdn-uicons.flaticon.com/2.3.0/uicons-regular-rounded/css/uicons-regular-rounded.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <link href="./output.css" rel="stylesheet">
        <link
            rel="stylesheet"
            href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"
            />
        <script src="https://cdn.tailwindcss.com"></script>
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
        <% String idSesion = request.getParameter("sesion_id"); %>
        <% String idUsuario = request.getParameter("id_usuario"); %>
        <% String correo = request.getParameter("correo"); %>
        <% String nombre = request.getParameter("nombre"); %>
        <% String apellido = request.getParameter("apellido"); %>
        <% String telefono = request.getParameter("telefono"); %>
        <% String tipoDocumento = request.getParameter("tipo_documento"); %>
        <% String documento = request.getParameter("documento"); %>
        <% String totalCarrito = request.getParameter("totalCarrito"); 
           
        if (nombre != null) {
            nombre = normalizeAndCapitalize(nombre);
        }

        if (apellido != null) {
            apellido = normalizeAndCapitalize(apellido);
        }
       
        %>
        <div class="flex flex-row space-x-2 mt-28 mx-6">
            <div class="w-full text-center"><i class="fi fi-rr-shopping-cart text-2xl text-yellow-600"></i></div>
            <div class="w-full text-center"><i class="fi fi-rr-ballot-check text-2xl text-yellow-600"></i></div>
            <div class="w-full text-center "><i class="fi fi-rr-credit-card text-2xl text-yellow-600 "></i></div>
        </div>
        <div class="flex flex-row space-x-2 mt-2 mx-6">
            <div class="h-1.5 w-full bg-gray-700 text-center"></div>
            <div class="h-1.5 w-full bg-gray-700 text-center"></div>
            <div class="h-1.5 w-full bg-gray-700 text-center animate__animated animate__lightSpeedInLeft"></div>
        </div>
        <div class="flex flex-row space-x-2 mx-6">
            <div class="w-full text-center">1. Carrito de compras</div>
            <div class="w-full text-center">2. Datos personales</div>
            <div class="w-full text-center">3. Método de Pago</div>
        </div>

        <div class="flex flex-col sm:flex-row  justify-between gap-6 mx-5 sm:mx-2 md:mx-20 mt-12 mb-12">

            <div class="container mx-auto ">
                <form action="procesarpago.jsp" method="post" class="bg-zinc-100 shadow-lg rounded-lg overflow-hidden p-6">
                    <% if (idUsuario != null) { %>
                    <input type="hidden" name="id_usuario" value="<%= idUsuario %>">
                    <% } else { %>
                    <input type="hidden" name="sesion_id" value="<%= idSesion %>">
                    <% } %>
                    <input type="hidden" name="totalCarrito" value="<%= totalCarrito %>" required>
                    <input type="hidden" name="correo" value="<%= correo %>" required>
                    <input type="hidden" name="nombre" value="<%= nombre %>" required>
                    <input type="hidden" name="apellido" value="<%= apellido %>" required>
                    <input type="hidden" name="telefono" value="<%= telefono %>" required>
                    <input type="hidden" name="tipo_documento" value="<%= tipoDocumento %>" required>
                    <input type="hidden" name="documento" value="<%= documento %>" required>
                    <h1 class="text-xl font-bold mb-4">Detalles de Tarjeta de Crédito</h1>
                    <div class="mb-4">
                        <label for="numero_tarjeta" class="block text-sm font-medium text-gray-700">Número de Tarjeta</label>
                        <input type="text" id=tarjetaInput name="numero_tarjeta"
                               class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:border-indigo-500"
                               placeholder="Ingresa el número de tu tarjeta" maxlength="19" required >
                    </div>
                    <div class="grid grid-cols-2 gap-4 mb-4">
                        <div>
                            <label for="fecha_vencimiento_mes" class="block text-sm font-medium text-gray-700">Fecha de Vencimiento (Mes)</label>
                            <select id="fecha_vencimiento_mes" name="fecha_vencimiento_mes" class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:border-indigo-500" required>
                                <option value="" disabled selected>Seleccionar mes</option>
                                <% for (int mes = 1; mes <= 12; mes++) { %>
                                <option value="<%= mes %>"><%= String.format("%02d", mes) %></option>
                                <% } %>
                            </select>
                        </div>
                        <div>
                            <label for="fecha_vencimiento_anio" class="block text-sm font-medium text-gray-700">Fecha de Vencimiento (Año)</label>
                            <select id="fecha_vencimiento_anio" name="fecha_vencimiento_anio" class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:border-indigo-500" required>
                                <option value="" disabled selected>Seleccionar año</option>
                                <% for (int anio = 2024; anio <= 2034; anio++) { %>
                                <option value="<%= anio %>"><%= anio %></option>
                                <% } %>
                            </select>
                        </div>
                    </div>
                    <div class="mb-4">
                        <label for="ccv" class="block text-sm font-medium text-gray-700">CCV</label>
                        <input type="password" id="ccv" name="ccv"
                               class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:border-indigo-500"
                               placeholder="Ingresa el CCV de tu tarjeta" minlength="3" maxlength="4" required>
                    </div>
                    <div class="mb-4">
                        <label for="nombre_apellido" class="block text-sm font-medium text-gray-700">Nombre y Apellido de la Tarjeta</label>
                        <input type="text" id="nombre_apellido" name="nombre_apellido"
                               class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:border-indigo-500"
                               placeholder="Ingresa el nombre y apellido de la tarjeta" required>
                    </div>
                    <div class="mb-4">
                        <label for="metodo_pago" class="block text-sm font-medium text-gray-700">Método de Pago</label>
                        <select id="metodo_pago" name="metodo_pago"
                                class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:border-indigo-500"
                                required>
                            <option value="1">Crédito</option>
                            <option value="2">Débito</option>
                        </select>
                    </div>
                    <div class="flex justify-center">
                        <button type="submit"
                                class="bg-yellow-700 text-white font-bold py-2 px-4 rounded border border-transparent hover:border-yellow-600 hover:bg-white hover:text-yellow-700 focus:outline-none focus:shadow-outline">Comprar Ahora</button>
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
        // Establecer la conexión a la base de datos
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
            pstmt.setString(1, idSesion);
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
<script>
    document.addEventListener("DOMContentLoaded", function () {
        var tarjetaInput = document.getElementById("tarjetaInput");
        tarjetaInput.addEventListener("input", function () {
            var valor = this.value.replace(/\s/g, ''); // Elimina espacios en blanco existentes
            var bloques = [];
            // Divide el número de tarjeta en bloques de 4 dígitos
            for (var i = 0; i < valor.length; i += 4) {
                bloques.push(valor.slice(i, i + 4));
            }
            // Combina los bloques con espacios en blanco entre ellos
            this.value = bloques.join(' ');
        });
    });
</script>
</body>

</html>