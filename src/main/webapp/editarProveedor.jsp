<%@ page import="java.sql.Connection, java.sql.PreparedStatement, java.sql.SQLException" %>
<%@ page import="datos.Mantenimiento" %> <!-- Asegúrate de tener la importación correcta -->

<%
    int idProveedor = Integer.parseInt(request.getParameter("id_proveedor"));
    String nombreProveedor = request.getParameter("nombre_proveedor");
    String telefonoProveedor = request.getParameter("telefono_proveedor");
    String correoProveedor = request.getParameter("correo_proveedor");
    String rucProveedor = request.getParameter("ruc_proveedor");

    // Preparar los datos para la conexión y la consulta SQL
    Mantenimiento mantenimiento = new Mantenimiento();
    Connection connection = null;
    PreparedStatement statement = null;

    try {
        // Establecer conexión a la base de datos
        mantenimiento.conectarBD();
        connection = mantenimiento.getConexion();

        // Consulta SQL para actualizar el proveedor
        String sql = "UPDATE Proveedores SET nombre_proveedor=?, telefono_proveedor=?, correo_proveedor=?, ruc_proveedor=? WHERE id_proveedor=?";
        statement = connection.prepareStatement(sql);
        statement.setString(1, nombreProveedor);
        statement.setString(2, telefonoProveedor);
        statement.setString(3, correoProveedor);
        statement.setString(4, rucProveedor);
        statement.setInt(5, idProveedor);

        // Ejecutar la actualización
        int filasActualizadas = statement.executeUpdate();

        // Verificar si se actualizaron registros
        if (filasActualizadas > 0) {
            // Redireccionar a la página de panel de proveedores
            response.sendRedirect("panelproveedores.jsp");
        } else {
            // Manejar el caso de error
            response.sendRedirect("error.jsp"); // Redireccionar a una página de error
        }

    } catch (SQLException e) {
        e.printStackTrace();
        response.sendRedirect("error.jsp"); // Redireccionar a una página de error
    } finally {
        // Cerrar recursos
        if (statement != null) {
            try {
                statement.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
%>
