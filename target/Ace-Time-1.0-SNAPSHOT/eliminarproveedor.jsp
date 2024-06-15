<%@ page import="java.sql.Connection, java.sql.PreparedStatement, java.sql.SQLException" %>
<%@ page import="datos.Mantenimiento" %> <!-- Aseg�rate de tener la importaci�n correcta -->

<%
    // Obtener el par�metro enviado desde el formulario
    int idProveedor = Integer.parseInt(request.getParameter("id_proveedor"));

    // Preparar los datos para la conexi�n y la consulta SQL
    Mantenimiento mantenimiento = new Mantenimiento();
    Connection connection = null;
    PreparedStatement statement = null;

    try {
        // Establecer conexi�n a la base de datos
        mantenimiento.conectarBD();
        connection = mantenimiento.getConexion();

        // Consulta SQL para actualizar el estado del proveedor
        String sql = "UPDATE Proveedores SET estado='eliminado' WHERE id_proveedor=?";
        statement = connection.prepareStatement(sql);
        statement.setInt(1, idProveedor);

        // Ejecutar la actualizaci�n
        int filasActualizadas = statement.executeUpdate();

        // Verificar si se actualiz� correctamente
        if (filasActualizadas > 0) {
            // Redireccionar a la p�gina de panel de proveedores
            response.sendRedirect("panelproveedores.jsp");
        } else {
            // Manejar el caso de error
            response.sendRedirect("error.jsp"); // Redireccionar a una p�gina de error
        }

    } catch (SQLException e) {
        e.printStackTrace();
        response.sendRedirect("error.jsp"); // Redireccionar a una p�gina de error
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
