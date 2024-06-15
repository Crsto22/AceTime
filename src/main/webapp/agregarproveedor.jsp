<%@ page import="java.sql.Connection, java.sql.PreparedStatement, java.sql.SQLException" %>
<%@ page import="datos.Mantenimiento" %> <!-- Aseg�rate de tener la importaci�n correcta -->

<%
    // Obtener los par�metros enviados desde el formulario
    String nombreProveedor = request.getParameter("nombre_proveedor");
    String telefonoProveedor = request.getParameter("telefono_proveedor");
    String correoProveedor = request.getParameter("correo_proveedor");
    String rucProveedor = request.getParameter("ruc_proveedor");

    // Preparar los datos para la conexi�n y la consulta SQL
    Mantenimiento mantenimiento = new Mantenimiento();
    Connection connection = null;
    PreparedStatement statement = null;

    try {
        // Establecer conexi�n a la base de datos
        mantenimiento.conectarBD();
        connection = mantenimiento.getConexion();

        // Consulta SQL para insertar un nuevo proveedor
        String sql = "INSERT INTO Proveedores (nombre_proveedor, telefono_proveedor, correo_proveedor, ruc_proveedor, estado) VALUES (?, ?, ?, ?, 'disponible')";
        statement = connection.prepareStatement(sql);
        statement.setString(1, nombreProveedor);
        statement.setString(2, telefonoProveedor);
        statement.setString(3, correoProveedor);
        statement.setString(4, rucProveedor);

        // Ejecutar la inserci�n
        int filasInsertadas = statement.executeUpdate();

        // Verificar si se insertaron registros
        if (filasInsertadas > 0) {
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
