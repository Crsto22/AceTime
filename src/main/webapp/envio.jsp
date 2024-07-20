<%@ page import="java.sql.*" %>
<%@ page import="datos.Mantenimiento" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String nombre = request.getParameter("nombre");
    String apellido = request.getParameter("apellido");
    String correo = request.getParameter("correo");
    String mensaje = request.getParameter("mensaje");

    // Guardar los datos en la base de datos
    Mantenimiento mantenimiento = new Mantenimiento();
    mantenimiento.conectarBD();
    Connection conn = mantenimiento.getConexion();
    PreparedStatement stmt = null;

    try {
        String sql = "INSERT INTO contactos (nombre, apellido, correo, mensaje) VALUES (?, ?, ?, ?)";
        stmt = conn.prepareStatement(sql);
        stmt.setString(1, nombre);
        stmt.setString(2, apellido);
        stmt.setString(3, correo);
        stmt.setString(4, mensaje);
        stmt.executeUpdate();

        // Redirigir a contactos.jsp con un parámetro indicando éxito
        response.sendRedirect("contactos.jsp?success=true");
    } catch (SQLException e) {
        e.printStackTrace();
        // Redirigir a contactos.jsp con un parámetro indicando error
        response.sendRedirect("contactos.jsp?success=false");
    } finally {
        try {
            if (stmt != null) stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        mantenimiento.cerrarBD();
    }
%>
