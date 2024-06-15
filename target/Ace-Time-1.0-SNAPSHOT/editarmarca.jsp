<%@ page import="java.sql.Connection, java.sql.PreparedStatement, java.sql.SQLException" %>
<%@ page import="datos.Mantenimiento" %>

<%
    // Recibir par�metros del formulario
    int id_marca = Integer.parseInt(request.getParameter("id_marca"));
    String nombre_marca = request.getParameter("nombre_marca");

    // Instanciar objetos de conexi�n y declaraci�n
    Mantenimiento mantenimiento = new Mantenimiento();
    Connection connection = null;
    PreparedStatement statement = null;

    try {
        mantenimiento.conectarBD();
        connection = mantenimiento.getConexion();

        // Preparar la consulta SQL para actualizar la marca
        String sql = "UPDATE Marca SET nombre_marca = ? WHERE id_marca = ?";
        statement = connection.prepareStatement(sql);
        statement.setString(1, nombre_marca);
        statement.setInt(2, id_marca);

        // Ejecutar la actualizaci�n
        int filasActualizadas = statement.executeUpdate();

        // Redireccionar a la p�gina principal de marcas (o a donde sea necesario)
        response.sendRedirect("panelmarcas.jsp");

    } catch (SQLException e) {
        e.printStackTrace();
        // Manejo de errores: podr�as mostrar un mensaje de error o redirigir a una p�gina de error
        response.sendRedirect("error.jsp");

    } finally {
        // Cerrar PreparedStatement
        if (statement != null) {
            try {
                statement.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        // Cerrar Connection
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
%>
