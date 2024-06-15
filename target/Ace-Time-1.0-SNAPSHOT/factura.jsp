<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="datos.Mantenimiento" %>
<%@ page import="dao.IMantenimiento" %>
<!DOCTYPE html>
<%
    String id_compra = request.getParameter("id_compra");

%>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Boleta de Venta</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/tailwindcss/2.2.19/tailwind.min.css">
    </head>
    <body class="bg-gray-100 p-8">
        <div class="max-w-3xl mx-auto bg-white rounded-lg shadow-md p-8">
            <div class="flex justify-between mb-6">
                <div>
                    <img src="img/ace.png" alt="Logo de la empresa" class="h-28">
                </div>
                <div>
                    <div class="border border-gray-300 rounded-md px-4 py-2">
                        <p class="font-bold">BOLETA DE VENTA</p>
                        <p class="font-bold text-center">ELECTRONICA</p>
                        <p class="font-bold text-3xl text-center">00<%= id_compra %></p>
                        <p>R.U.C N 12345678901</p>
                    </div>
                </div>
            </div>
            <div class="border-gray-300 rounded-md mb-2 p-4">
                <p>Ace time</p>
                <p>Peru-Lima-San Juan de Lurigancho</p>
            </div>

            <div class="mb-8 border border-gray-300 rounded-md p-4 flex justify-between">
                <%
    String id_comprador = request.getParameter("id_comprador");
    String id_usuario_str = request.getParameter("id_usuario");
    String fecha_comprobante = request.getParameter("fecha_comprobante");


                    // Convertir id_usuario a entero, manejando valores nulos o vacíos
                    int id_usuario = 0;
                    if (id_usuario_str != null && !id_usuario_str.isEmpty()) {
                        id_usuario = Integer.parseInt(id_usuario_str);
                    }

                    Mantenimiento mantenimiento = new Mantenimiento();
                    Connection connection = null;
                    PreparedStatement statement = null;
                    ResultSet resultSet = null;

                    try {
                        // Establecer la conexión con la base de datos
                        mantenimiento.conectarBD();
                        connection = mantenimiento.getConexion();
                        String query;

                        if (id_usuario == 0) {
                            query = "SELECT dt.nombre AS nombre_comprador, " +
                                    "dt.apellido AS apellido_comprador, " +
                                    "dt.correo AS correo_comprador, " +
                                    "dt.Num_Documento AS numero_documento_comprador " +
                                    "FROM Datos_comprador dt " +
                                    "WHERE dt.id_comprador = ?";
                            statement = connection.prepareStatement(query);
                            statement.setString(1, id_comprador);
                        } else {
                            query = "SELECT u.nombre AS nombre_usuario, " +
                                    "u.apellido AS apellido_usuario, " +
                                    "u.correo AS correo_usuario, " +
                                    "u.Num_Documento AS numero_documento_usuario " +
                                    "FROM Usuarios u " +
                                    "WHERE u.id_usuario = ?";
                            statement = connection.prepareStatement(query);
                            statement.setString(1, id_usuario_str);
                        }

                        resultSet = statement.executeQuery();
                        if (resultSet.next()) {
                %>
                <div>
                    <%
                        if (id_usuario == 0) {
                    %>
                    <p><span class="font-bold">Señor(es):</span> <%= resultSet.getString("nombre_comprador") %> <%= resultSet.getString("apellido_comprador") %></p>
                    <p><span class="font-bold">Dirección:</span> <%= resultSet.getString("correo_comprador") %></p>
                    <p><span class="font-bold">DNI:</span> <%= resultSet.getString("numero_documento_comprador") %></p>
                    <%
                        } else {
                    %>
                    <p><span class="font-bold">Señor(es):</span> <%= resultSet.getString("nombre_usuario") %> <%= resultSet.getString("apellido_usuario") %></p>
                    <p><span class="font-bold">Dirección:</span> <%= resultSet.getString("correo_usuario") %></p>
                    <p><span class="font-bold">DNI:</span> <%= resultSet.getString("numero_documento_usuario") %></p>
                    <%
                        }
                    %>
                    <p><span class="font-bold">Tipo de Moneda:</span> SOL</p>
                    <p><span class="font-bold">Método de Pago:</span> Al contado</p>
                </div>
                <div>
                    <p><span class="font-bold">Fecha de Emisión:</span> <%= fecha_comprobante %></p>
                </div>
                <%
                        } else {
                            out.println("<p>No se encontró la compra con el ID proporcionado.</p>");
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    } finally {
                        try {
                            if (resultSet != null) resultSet.close();
                            if (statement != null) statement.close();
                            mantenimiento.cerrarBD();
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    }
                %>
            </div>

            <div>
                <table class="w-full mb">
                    <thead class="bg-gray-200">
                        <tr>
                            <th class="py-2">Item</th>
                            <th class="py-2">Descripción</th>
                            <th class="py-2">Cantidad</th>
                            <th class="py-2">Precio Unitario </th>
                            <th class="py-2">Total</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%


    Mantenimiento mantenimiento1 = new Mantenimiento();
    Connection connection2 = null;
    PreparedStatement statement2 = null;
    ResultSet resultSet2 = null;

    try {
        // Establecer la conexión y realizar la consulta
        mantenimiento.conectarBD();
        connection2 = mantenimiento.getConexion();
        String query2;

        if (id_usuario == 0) {
            query2 = "SELECT producto, cantidad, precio, fecha_comprobante, total " +
                     "FROM Comprobante " +
                     "WHERE id_comprador = ? AND fecha_comprobante = ?";
            statement2 = connection2.prepareStatement(query2);
            statement2.setString(1, id_comprador);
        } else {
            query2 = "SELECT producto, cantidad, precio, fecha_comprobante, total " +
                     "FROM Comprobante " +
                     "WHERE id_usuario = ? AND fecha_comprobante = ?";
            statement2 = connection2.prepareStatement(query2);
            statement2.setInt(1, id_usuario);
        }
        statement2.setString(2, fecha_comprobante);

        resultSet2 = statement2.executeQuery();
        double total = 0.0;
        int itemCounter = 1;
                        %>
                    <table class="min-w-full bg-white border border-gray-300">
                        <thead class="bg-gray-50">
                            <tr>
                                <th class="border px-4 py-2">#</th>
                                <th class="border px-4 py-2">Producto</th>
                                <th class="border px-4 py-2">Cantidad</th>
                                <th class="border px-4 py-2">Precio</th>
                                <th class="border px-4 py-2">Total</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                    while (resultSet2.next()) {
                                        double precioTotalProducto = resultSet2.getDouble("precio") * resultSet2.getInt("cantidad");
                                        total += precioTotalProducto;
                            %>
                            <tr>
                                <td class="border px-4 py-2"><%= itemCounter++ %></td>
                                <td class="border px-4 py-2"><%= resultSet2.getString("producto") %></td>
                                <td class="border px-4 py-2"><%= resultSet2.getInt("cantidad") %></td>
                                <td class="border px-4 py-2"><%= resultSet2.getDouble("precio") %></td>
                                <td class="border px-4 py-2"><%= precioTotalProducto %></td>
                            </tr>
                            <%
                                    }
                                    DecimalFormat df = new DecimalFormat("#0.00");

                                    double igv = total * 0.18;
                                    double subtotaligv = total - igv;

                                    String igvFormateado = df.format(igv);
                                    String subtotaligvFormateado = df.format(subtotaligv);
                                    String totalFormateado = df.format(total);
                            %>
                        </tbody>
                    </table>
                    <div class="border-gray-300 rounded-md flex justify-end mt-2">
                        <table>
                            <tbody class="bg-gray-200">
                                <tr>
                                    <td class="border px-4 py-2 font-bold">Subtotal sin IGV:</td>
                                    <td class="border px-4 py-2">S/<%= subtotaligvFormateado %></td>
                                </tr>
                                <tr>
                                    <td class="border px-4 py-2 font-bold">IGV (18%):</td>
                                    <td class="border px-4 py-2">S/<%= igvFormateado %></td>
                                </tr>
                                <tr>
                                    <td class="border px-4 py-2 font-bold">Total:</td>
                                    <td class="border px-4 py-2">S/<%= totalFormateado %></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <%
                        } catch (Exception e) {
                            out.println("Error de conexión: " + e.getMessage());
                        } finally {
                            try {
                                if (resultSet2 != null) resultSet2.close();
                                if (statement2 != null) statement2.close();
                                mantenimiento1.cerrarBD();
                            } catch (SQLException e) {
                                e.printStackTrace();
                            }
                        }
                    %>
            </div>
        </div>  
    </div>





    <div class="mt-4 flex justify-center">
        <button id="imprimirBtn" class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">Imprimir</button>
    </div>
    <script>
        const imprimirBtn = document.getElementById('imprimirBtn');

        imprimirBtn.addEventListener('click', () => {
            window.print();
        });
    </script>
</body>
</html>
