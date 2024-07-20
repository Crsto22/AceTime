<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, datos.Mantenimiento" %>

<%! 
    public String capitalizeWords(String str) {
        String[] words = str.split("\\s+");
        StringBuilder capitalized = new StringBuilder();

        for (String word : words) {
            if (word.length() > 0) {
                capitalized.append(Character.toUpperCase(word.charAt(0)))
                           .append(word.substring(1).toLowerCase())
                           .append(" ");
            }
        }
        return capitalized.toString().trim();
    }
%>
<%
    Integer idUsuario = (Integer) session.getAttribute("idUsuario");

    String nombreUsuario = request.getParameter("nombreUsuario");
    String nombre = request.getParameter("nombre").trim().replaceAll("\\s+", " ");
    String apellido = request.getParameter("apellido").trim().replaceAll("\\s+", " ");
    String correo = request.getParameter("correo");
    String contrasena = request.getParameter("contrasena");
    String tipoDocumento = request.getParameter("tipoDocumento");
    String numeroDocumento = request.getParameter("numeroDocumento");
    String telefono = request.getParameter("telefono");
    nombre = capitalizeWords(nombre);
    apellido = capitalizeWords(apellido);

    Mantenimiento mantenimiento = new Mantenimiento();
    Connection conexion = null;
    PreparedStatement declaracion = null;
    ResultSet resultado = null;

    try {
        // Establecer la conexión a la base de datos utilizando el método conectarBD
        mantenimiento.conectarBD();
        conexion = mantenimiento.getConexion();
        
        // Comprobar si ya existe un usuario con el mismo nombre de usuario
        String sqlCheck = "SELECT COUNT(*) FROM Usuarios WHERE nombre_usuario = ? AND id_usuario != ?";
        declaracion = conexion.prepareStatement(sqlCheck);
        declaracion.setString(1, nombreUsuario);
        declaracion.setInt(2, idUsuario);
        resultado = declaracion.executeQuery();
        
        if (resultado.next() && resultado.getInt(1) > 0) {
        
             if ("admin".equals(session.getAttribute("rol"))) {
             
                    response.sendRedirect("panelcuenta.jsp?error=nombre_usuario_existe");
                } else {
            response.sendRedirect("AjustesUsuario.jsp?error=nombre_usuario_existe");
                }
        } else {
            // Si no existe un usuario con ese nombre, proceder a actualizar el usuario
            String sqlActualizar = "UPDATE Usuarios SET nombre_usuario = ?, nombre = ?, apellido = ?, correo = ?, contrasena = ?, tipo_documento_id = ?, Num_Documento = ?, telefono_movil = ? WHERE id_usuario = ?";
            declaracion = conexion.prepareStatement(sqlActualizar);
            declaracion.setString(1, nombreUsuario);
            declaracion.setString(2, nombre);
            declaracion.setString(3, apellido);
            declaracion.setString(4, correo);
            declaracion.setString(5, contrasena);
            declaracion.setInt(6, Integer.parseInt(tipoDocumento));
            declaracion.setString(7, numeroDocumento);
            declaracion.setString(8, telefono);
            declaracion.setInt(9, idUsuario);

            int filasActualizadas = declaracion.executeUpdate();

            if (filasActualizadas > 0) {
                session.setAttribute("nombreUsuario", nombreUsuario);
                if ("admin".equals(session.getAttribute("rol"))) {
                    response.sendRedirect("panelcuenta.jsp");
                } else {
                    response.sendRedirect("AjustesUsuario.jsp?success=Datos actualizados exitosamente.");
                }
            } else {
                if ("admin".equals(session.getAttribute("rol"))) {
                    response.sendRedirect("panelcuenta.jsp?error=No se pudo actualizar los datos.");
                } else {
                    response.sendRedirect("AjustesUsuario.jsp?error=No se pudo actualizar los datos.");
                }
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("AjustesUsuario.jsp?error=Ocurrió un error durante la actualización.");
    } finally {
        // Cerrar recursos en el bloque finally
        try {
            if (resultado != null) resultado.close();
            if (declaracion != null) declaracion.close();
            mantenimiento.cerrarBD();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
