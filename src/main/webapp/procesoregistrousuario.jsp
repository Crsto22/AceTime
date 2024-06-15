<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="datos.Mantenimiento" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Proceso Registro Usuario</title>
    <!-- Aquí puedes incluir cualquier estilo CSS necesario -->
</head>
<body>
    <%! 
        // Función para capitalizar la primera letra de cada palabra
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

    <%-- Recuperar los datos enviados desde el formulario --%>
    <% 
        String nombreUsuario = request.getParameter("nombreUsuario");
        String correo = request.getParameter("correo");
        String contrasena = request.getParameter("password");
        String nombre = request.getParameter("nombre").trim().replaceAll("\\s+", " ");
        String apellido = request.getParameter("apellido").trim().replaceAll("\\s+", " ");
        int tipoDocumento = Integer.parseInt(request.getParameter("tipo_documento")); // Convertir a entero
        String numeroDocumento = request.getParameter("numeroDocumento");
        String telefono = request.getParameter("telefono");

        // Aplicar la función de capitalización a nombre y apellido
        nombre = capitalizeWords(nombre);
        apellido = capitalizeWords(apellido);
    %>
    
    <%
        // Crear una instancia de Mantenimiento y conectar a la base de datos
        Mantenimiento mantenimiento = new Mantenimiento();
        mantenimiento.conectarBD();
        Connection conexion = mantenimiento.getConexion();
        PreparedStatement declaracion = null;
        ResultSet resultado = null;

        try {
            // Comprobar si ya existe un usuario con el mismo nombre de usuario
            String sqlCheck = "SELECT COUNT(*) FROM Usuarios WHERE nombre_usuario = ?";
            declaracion = conexion.prepareStatement(sqlCheck);
            declaracion.setString(1, nombreUsuario);
            resultado = declaracion.executeQuery();
            
            if (resultado.next() && resultado.getInt(1) > 0) {
                // Si ya existe un usuario con ese nombre, redirigir a index.jsp con parámetro de error
                response.sendRedirect("index.jsp?error=nombre_usuario_existe");
            } else {
                // Si no existe un usuario con ese nombre, proceder a insertar el nuevo usuario
                String sqlInsert = "INSERT INTO Usuarios (nombre_usuario, correo, contrasena, nombre, apellido, tipo_documento_id, Num_Documento, telefono_movil, rol) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
                declaracion = conexion.prepareStatement(sqlInsert);

                // Establecer los valores de los parámetros
                declaracion.setString(1, nombreUsuario);
                declaracion.setString(2, correo);
                declaracion.setString(3, contrasena);
                declaracion.setString(4, nombre);
                declaracion.setString(5, apellido);
                declaracion.setInt(6, tipoDocumento);
                declaracion.setString(7, numeroDocumento);
                declaracion.setString(8, telefono);
                declaracion.setString(9, "cliente");

                // Ejecutar la consulta SQL para insertar el nuevo usuario
                int filasInsertadas = declaracion.executeUpdate();

                // Verificar si se insertaron filas correctamente
                if (filasInsertadas > 0) {
                    // Redirigir a index.jsp con parámetro de éxito
                    response.sendRedirect("index.jsp?success=true");
                } else {
    %>
                    <div>
                        <h2>Error en el registro</h2>
                        <p>No se pudo registrar el usuario.</p>
                    </div>
    <%
                }
            }
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
            try {
                if (resultado != null) resultado.close();
                if (declaracion != null) declaracion.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
            mantenimiento.cerrarBD();
        }
    %>
    
    <%-- Aquí puedes incluir cualquier pie de página, scripts necesarios, etc. --%>
</body>
</html>
