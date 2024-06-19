<%@ page import="java.sql.*" %>
<%@ page import="datos.Mantenimiento" %>
<%@ page import="dao.IMantenimiento" %>
<%
    // Recuperar los datos del formulario
    String idUsuario = request.getParameter("id_usuario");
    String sesionId = request.getParameter("sesion_id");
    String totalCarrito = request.getParameter("totalCarrito");
    String correo = request.getParameter("correo");
    String nombre = request.getParameter("nombre");
    String apellido = request.getParameter("apellido");
    String telefono = request.getParameter("telefono");
    String tipoDocumento = request.getParameter("tipo_documento");
    String documento = request.getParameter("documento");
    String metodoPago = request.getParameter("metodo_pago");

    // Validar que los campos requeridos no est?n vac?os
    if (nombre == null || apellido == null || correo == null || telefono == null || documento == null) {
        out.println("Error: Todos los campos son obligatorios.");
    } else {
     Mantenimiento mantenimiento = new Mantenimiento();
        Connection con = null;
        PreparedStatement pstmtComprador = null;
        PreparedStatement pstmtDetalleCompra = null;
        PreparedStatement pstmtProductosCarrito = null;
        PreparedStatement pstmtProductosComprados = null;
        PreparedStatement pstmtUpdateProductos = null;
        PreparedStatement pstmtEliminarCarrito = null;
        ResultSet generatedKeysComprador = null;
        ResultSet generatedKeysDetalleCompra = null;

         try {
            mantenimiento.conectarBD();
            con = mantenimiento.getConexion();
            con.setAutoCommit(false);
            
            if (sesionId != null) {
                // Caso cuando sesionId no es null
                // Inserci?n en Datos_comprador
                String sqlComprador = "INSERT INTO Datos_comprador (nombre, apellido, correo, telefono_movil, tipo_documento_id, Num_Documento) VALUES (?, ?, ?, ?, ?, ?)";
                pstmtComprador = con.prepareStatement(sqlComprador, Statement.RETURN_GENERATED_KEYS);
                pstmtComprador.setString(1, nombre);
                pstmtComprador.setString(2, apellido);
                pstmtComprador.setString(3, correo);
                pstmtComprador.setString(4, telefono);
                pstmtComprador.setString(5, tipoDocumento);
                pstmtComprador.setString(6, documento);
                pstmtComprador.executeUpdate();
                generatedKeysComprador = pstmtComprador.getGeneratedKeys();

                if (generatedKeysComprador.next()) {
                    int id_comprador = generatedKeysComprador.getInt(1);

                    // Inserci?n en Detalle_Compra
                    String sqlDetalleCompra = "INSERT INTO Detalle_Compra (id_comprador, metodo_pago_id, total_compra) VALUES (?, ?, ?)";
                    pstmtDetalleCompra = con.prepareStatement(sqlDetalleCompra, Statement.RETURN_GENERATED_KEYS);
                    pstmtDetalleCompra.setInt(1, id_comprador);
                    pstmtDetalleCompra.setString(2, metodoPago);
                    pstmtDetalleCompra.setString(3, totalCarrito);
                    pstmtDetalleCompra.executeUpdate();
                    generatedKeysDetalleCompra = pstmtDetalleCompra.getGeneratedKeys();

                    if (generatedKeysDetalleCompra.next()) {
                        int id_compra = generatedKeysDetalleCompra.getInt(1);

                        // Obtener productos del carrito
                        String sqlProductosCarrito = "SELECT id_producto, cantidad FROM carrito WHERE sesion_id = ?";
                        pstmtProductosCarrito = con.prepareStatement(sqlProductosCarrito);
                        pstmtProductosCarrito.setString(1, sesionId);
                        ResultSet rsProductosCarrito = pstmtProductosCarrito.executeQuery();

                        // Insertar en Productos_Comprados y actualizar Productos
                        String sqlProductosComprados = "INSERT INTO Productos_Comprados (id_compra, id_producto, cantidad_comprado) VALUES (?, ?, ?)";
                        pstmtProductosComprados = con.prepareStatement(sqlProductosComprados);

                        while (rsProductosCarrito.next()) {
                            int id_producto = rsProductosCarrito.getInt("id_producto");
                            int cantidad_comprada = rsProductosCarrito.getInt("cantidad");

                            pstmtProductosComprados.setInt(1, id_compra);
                            pstmtProductosComprados.setInt(2, id_producto);
                            pstmtProductosComprados.setInt(3, cantidad_comprada);
                            pstmtProductosComprados.addBatch();

                            String sqlUpdateProductos = "UPDATE Productos SET cantidad = cantidad - ? WHERE id_producto = ?";
                            pstmtUpdateProductos = con.prepareStatement(sqlUpdateProductos);
                            pstmtUpdateProductos.setInt(1, cantidad_comprada);
                            pstmtUpdateProductos.setInt(2, id_producto);
                            pstmtUpdateProductos.executeUpdate();
                        }

                        pstmtProductosComprados.executeBatch();
                        con.commit();

                        // Eliminar carrito
                        String sqlEliminarCarrito = "DELETE FROM carrito WHERE sesion_id = ?";
                        pstmtEliminarCarrito = con.prepareStatement(sqlEliminarCarrito);
                        pstmtEliminarCarrito.setString(1, sesionId);
                        pstmtEliminarCarrito.executeUpdate();

                        response.sendRedirect("enviocomprobante.jsp?id_compra=" + id_compra);
                    } else {
                        out.println("Error al obtener el ID de compra.");
                    }
                } else {
                    out.println("Error al obtener el ID del comprador.");
                }
            } else if (idUsuario != null) {
                // Caso cuando idUsuario no es null
                // Inserci?n en Detalle_Compra usando idUsuario
                String sqlDetalleCompra = "INSERT INTO Detalle_Compra (id_usuario, metodo_pago_id, total_compra) VALUES (?, ?, ?)";
                pstmtDetalleCompra = con.prepareStatement(sqlDetalleCompra, Statement.RETURN_GENERATED_KEYS);
                pstmtDetalleCompra.setInt(1, Integer.parseInt(idUsuario));
                pstmtDetalleCompra.setString(2, metodoPago);
                pstmtDetalleCompra.setString(3, totalCarrito);
                pstmtDetalleCompra.executeUpdate();
                generatedKeysDetalleCompra = pstmtDetalleCompra.getGeneratedKeys();

                if (generatedKeysDetalleCompra.next()) {
                    int id_compra = generatedKeysDetalleCompra.getInt(1);

                    // Obtener productos del carrito
                    String sqlProductosCarrito = "SELECT id_producto, cantidad FROM carrito WHERE id_usuario = ?";
                    pstmtProductosCarrito = con.prepareStatement(sqlProductosCarrito);
                    pstmtProductosCarrito.setInt(1, Integer.parseInt(idUsuario));
                    ResultSet rsProductosCarrito = pstmtProductosCarrito.executeQuery();

                    // Insertar en Productos_Comprados y actualizar Productos
                    String sqlProductosComprados = "INSERT INTO Productos_Comprados (id_compra, id_producto, cantidad_comprado) VALUES (?, ?, ?)";
                    pstmtProductosComprados = con.prepareStatement(sqlProductosComprados);

                    while (rsProductosCarrito.next()) {
                        int id_producto = rsProductosCarrito.getInt("id_producto");
                        int cantidad_comprada = rsProductosCarrito.getInt("cantidad");

                        pstmtProductosComprados.setInt(1, id_compra);
                        pstmtProductosComprados.setInt(2, id_producto);
                        pstmtProductosComprados.setInt(3, cantidad_comprada);
                        pstmtProductosComprados.addBatch();

                        String sqlUpdateProductos = "UPDATE Productos SET cantidad = cantidad - ? WHERE id_producto = ?";
                        pstmtUpdateProductos = con.prepareStatement(sqlUpdateProductos);
                        pstmtUpdateProductos.setInt(1, cantidad_comprada);
                        pstmtUpdateProductos.setInt(2, id_producto);
                        pstmtUpdateProductos.executeUpdate();
                    }

                    pstmtProductosComprados.executeBatch();
                    con.commit();

                    // Eliminar carrito
                    String sqlEliminarCarrito = "DELETE FROM carrito WHERE id_usuario = ?";
                    pstmtEliminarCarrito = con.prepareStatement(sqlEliminarCarrito);
                    pstmtEliminarCarrito.setInt(1, Integer.parseInt(idUsuario));
                    pstmtEliminarCarrito.executeUpdate();

                    response.sendRedirect("enviocomprobante.jsp?id_compra=" + id_compra);
                } else {
                    out.println("Error al obtener el ID de compra.");
                }
            } else {
                out.println("Error: Debe proporcionar un id_usuario o un sesion_id.");
            }
        } catch (SQLException e) {
            try {
                if (con != null) {
                    con.rollback(); // Deshacer la transacci?n en caso de error
                }
            } catch (SQLException ex) {
                out.println("Error al realizar el rollback: " + ex.getMessage());
            }
            response.sendRedirect("SinStock.jsp");
            
            
        } finally {
            try {
                if (con != null) {
                    con.setAutoCommit(true); // Restaurar autocommit
                    con.close();
                }
                if (generatedKeysComprador != null) generatedKeysComprador.close();
                if (generatedKeysDetalleCompra != null) generatedKeysDetalleCompra.close();
                if (pstmtComprador != null) pstmtComprador.close();
                if (pstmtDetalleCompra != null) pstmtDetalleCompra.close();
                if (pstmtProductosComprados != null) pstmtProductosComprados.close();
                if (pstmtUpdateProductos != null) pstmtUpdateProductos.close();
                if (pstmtProductosCarrito != null) pstmtProductosCarrito.close();
                if (pstmtEliminarCarrito != null) pstmtEliminarCarrito.close();
            } catch (SQLException ex) {
                out.println("Error al cerrar recursos: " + ex.getMessage());
            }
        }
    }
%>