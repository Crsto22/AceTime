<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="datos.Mantenimiento" %>
<%@ page import="dao.IMantenimiento" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Proceso de inicio de sesión</title>
    </head>
    <body>
        <% 
            String nombreUsuario = request.getParameter("usuario");
            String password = request.getParameter("password");
            String rol = "";
            int idUsuario = 0;

            // Instanciar la clase Mantenimiento y conectar a la base de datos
            Mantenimiento mantenimiento = new Mantenimiento();
            mantenimiento.conectarBD();
            Connection conexion = mantenimiento.getConexion();
        %>

        <%
            try {
                // Crear una sentencia SQL para buscar el usuario
                String sql = "SELECT id_usuario, rol FROM Usuarios WHERE nombre_usuario = ? AND contrasena = ?";
                PreparedStatement consulta = conexion.prepareStatement(sql);

                // Establecer los valores de los parámetros
                consulta.setString(1, nombreUsuario);
                consulta.setString(2, password);

                // Ejecutar la consulta SQL para buscar el usuario
                ResultSet resultado = consulta.executeQuery();

                // Verificar si se encontró el usuario
                if (resultado.next()) {
                    idUsuario = resultado.getInt("id_usuario");
                    rol = resultado.getString("rol");
                    // Crear una sesión y almacenar el nombre de usuario, id_usuario y el rol
                    HttpSession sesion = request.getSession();
                    sesion.setAttribute("idUsuario", idUsuario);
                    sesion.setAttribute("nombreUsuario", nombreUsuario);
                    sesion.setAttribute("rol", rol);
                    // Redireccionar según el rol del usuario
                    if (rol.equals("admin")) {
                        response.sendRedirect("CambioRol.jsp");
                    } else if (rol.equals("cliente")) {
                        response.sendRedirect("index.jsp?succes=true");
                    }
                } else {
                    response.sendRedirect("index.jsp?error=true");
                }

                // Cerrar la consulta y el resultado
                resultado.close();
                consulta.close();
            } catch (SQLException e) {
                // Manejar cualquier error de la base de datos
        %>
        <div>
            <h2>Error en la base de datos</h2>
            <p>Ocurrió un error al intentar conectar con la base de datos.</p>
            <p><%= e.getMessage() %></p>
        </div>
        <%
                e.printStackTrace();
            } finally {
                // Cerrar la conexión a la base de datos
                mantenimiento.cerrarBD();
            }
        %>

        <%-- Aquí puedes incluir cualquier pie de página, scripts necesarios, etc. --%>
    </body>
</html>
