<%@ page import="java.sql.*" %>
<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet" %>
<%@ page import="datos.Mantenimiento" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet" %>

<%
    String id_compra = request.getParameter("id_compra");

    if (id_compra != null && id_compra.matches("\\d+")) {
        int idCompra = Integer.parseInt(id_compra);

        // Declarar e inicializar las variables id_comprador y id_usuario
        int id_comprador = 0;
        int id_usuario = 0;
        String fecha_comprobante = "";

        Mantenimiento mantenimiento = new Mantenimiento();
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            // Establecer la conexión a la base de datos utilizando el método conectarBD
            mantenimiento.conectarBD();
            con = mantenimiento.getConexion();

            // Consulta SQL para obtener los productos comprados en la compra con id_compra especificada
            String sql = "SELECT usr.id_usuario, dt.id_comprador, pc.id_producto, m.nombre_marca AS marca_producto, " +
             "pr.descripcion AS descripcion_producto, pr.precio, pc.cantidad_comprado, dc.id_compra " +
             "FROM Detalle_Compra dc " +
             "INNER JOIN Metodo_pago mp ON dc.metodo_pago_id = mp.id_metodo_pago " +
             "INNER JOIN Productos_Comprados pc ON dc.id_compra = pc.id_compra " +
             "INNER JOIN Productos pr ON pc.id_producto = pr.id_producto " +
             "INNER JOIN Marca m ON pr.marca_id = m.id_marca " +  // Unir con la tabla Marca
             "LEFT JOIN Usuarios usr ON dc.id_usuario = usr.id_usuario " +
             "LEFT JOIN Datos_comprador dt ON dc.id_comprador = dt.id_comprador " +
             "WHERE dc.id_compra = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, idCompra); // Establecer el valor de id_compra en la consulta SQL
            rs = pstmt.executeQuery();

            while (rs.next()) {
                id_comprador = rs.getInt("id_comprador");
                id_usuario = rs.getInt("id_usuario");
                int id_producto = rs.getInt("id_producto");
                String marca_producto = rs.getString("marca_producto");
                String descripcion_producto = rs.getString("descripcion_producto");
                double precio = rs.getDouble("precio");
                int cantidad_comprado = rs.getInt("cantidad_comprado");

                // Crear una nueva conexión para insertar los datos en la tabla Comprobante
                Connection insertCon = null;
                PreparedStatement insertPstmt = null;

                try {
                    // Establecer la conexión a la base de datos utilizando el método conectarBD
                    mantenimiento.conectarBD();
                    insertCon = mantenimiento.getConexion();

                    // Verificar si se usa id_comprador o id_usuario para la inserción
                    String insertSql;
                    if (id_usuario == 0) {
                        // Si id_usuario es null, usar id_comprador
                        insertSql = "INSERT INTO Comprobante (id_comprador, producto, cantidad, precio, total) VALUES (?, ?, ?, ?, ?)";
                        insertPstmt = insertCon.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS);
                        insertPstmt.setInt(1, id_comprador);
                    } else {
                        // Si id_usuario no es null, usar id_usuario
                        insertSql = "INSERT INTO Comprobante (id_usuario, producto, cantidad, precio, total) VALUES (?, ?, ?, ?, ?)";
                        insertPstmt = insertCon.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS);
                        insertPstmt.setInt(1, id_usuario);
                    }

                    insertPstmt.setString(2, marca_producto + " " + descripcion_producto); // Producto como combinación de marca y descripción
                    insertPstmt.setInt(3, cantidad_comprado);
                    insertPstmt.setDouble(4, precio);
                    double total = precio * cantidad_comprado; // Calcular el total
                    insertPstmt.setDouble(5, total);

                    // Ejecutar la inserción en la tabla Comprobante
                    insertPstmt.executeUpdate();

                    // Obtener la fecha_comprobante de la inserción
                    ResultSet generatedKeys = insertPstmt.getGeneratedKeys();
                    if (generatedKeys.next()) {
                        int id_comprobante = generatedKeys.getInt(1);

                        // Obtener la fecha_comprobante de la tabla Comprobante
                        String fechaSql = "SELECT fecha_comprobante FROM Comprobante WHERE id_comprobante = ?";
                        PreparedStatement fechaPstmt = insertCon.prepareStatement(fechaSql);
                        fechaPstmt.setInt(1, id_comprobante);
                        ResultSet fechaRs = fechaPstmt.executeQuery();
                        if (fechaRs.next()) {
                            fecha_comprobante = fechaRs.getString("fecha_comprobante");
                        }
                        fechaRs.close();
                        fechaPstmt.close();
                    }
                    generatedKeys.close();
                } catch (SQLException e) {
                    out.println("Error al insertar datos en la tabla Comprobante: " + e.getMessage());
                } finally {
                    // Cerrar recursos de la inserción
                    mantenimiento.cerrarBD();
                }
            }

            // Cerrar recursos de la consulta
            rs.close();
            pstmt.close();

            // Redirigir a cargandocompra.jsp después de la inserción exitosa
            response.sendRedirect("cargandocompra.jsp?id_compra=" + id_compra + "&id_comprador=" + id_comprador + "&id_usuario=" + id_usuario + "&fecha_comprobante=" + fecha_comprobante);
        } catch (SQLException e) {
            out.println("Error: " + e.getMessage());
        } finally {
            // Asegurarse de cerrar recursos
            mantenimiento.cerrarBD();
        }
    } else {
        out.println("Error: ID de compra inválida.");
    }
%>
