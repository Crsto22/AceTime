<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="datos.Mantenimiento" %>
<%@ page import="dao.IMantenimiento" %>
<%
    String producto_id = request.getParameter("id_producto");
    String sesion_id = request.getParameter("sesion_id");
    Integer idUsuario = (Integer) session.getAttribute("idUsuario");

    // Instanciar la clase Mantenimiento y conectar a la base de datos
    Mantenimiento mantenimiento = new Mantenimiento();
    mantenimiento.conectarBD();
    Connection conn = mantenimiento.getConexion();

    try {
        String query;
        PreparedStatement pstmt;

        if (idUsuario != null) {
            // Si hay un idUsuario en la sesión, eliminar el producto del carrito usando id_usuario
            query = "DELETE FROM carrito WHERE id_producto = ? AND id_usuario = ?";
            pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, Integer.parseInt(producto_id));
            pstmt.setInt(2, idUsuario);
        } else {
            // Si no hay idUsuario en la sesión, eliminar el producto del carrito usando sesion_id
            query = "DELETE FROM carrito WHERE id_producto = ? AND sesion_id = ?";
            pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, Integer.parseInt(producto_id));
            pstmt.setString(2, sesion_id);
        }

        pstmt.executeUpdate();
        response.sendRedirect("carito.jsp");
    } catch (SQLException e) {
        out.print("Error al eliminar el producto del carrito: " + e.getMessage());
    } finally {
        mantenimiento.cerrarBD();
    }
%>
