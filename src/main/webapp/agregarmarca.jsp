<%@ page import="java.sql.Connection, java.sql.PreparedStatement, java.sql.SQLException" %>
<%@ page import="datos.Mantenimiento" %> <!-- Asegúrate de tener la importación correcta -->

<%
    // Obtener el parámetro enviado desde el formulario
    String nombreMarca = request.getParameter("marca");

    // Preparar los datos para la conexión y la consulta SQL
    Mantenimiento mantenimiento = new Mantenimiento();
    Connection connection = null;
    PreparedStatement statement = null;

    try {
        // Establecer conexión a la base de datos
        mantenimiento.conectarBD();
        connection = mantenimiento.getConexion();

        // Consulta SQL para insertar una nueva marca
        String sql = "INSERT INTO Marca (nombre_marca, estado) VALUES (?, 'disponible')";
        statement = connection.prepareStatement(sql);
        statement.setString(1, nombreMarca);

        // Ejecutar la inserción
        int filasInsertadas = statement.executeUpdate();

        // Verificar si se insertó correctamente
        if (filasInsertadas > 0) {
            // Redireccionar a la página principal de marcas
            response.sendRedirect("panelmarcas.jsp");
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
