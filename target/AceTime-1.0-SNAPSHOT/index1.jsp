<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Clientes</title>
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            padding: 8px 12px;
            border: 1px solid #ddd;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
    </style>
</head>
<body>
    <h2>Lista de Clientes</h2>
    <table>
        <tr>
            <th>ID</th>
            <th>Nombre</th>
            <th>Apellido</th>
            <th>Correo</th>
        </tr>
        <%
            // Definir las variables de conexión
            final String url = "jdbc:mysql://database-1.c1wkem4w074p.us-east-2.rds.amazonaws.com:3306/mibase";
            final String usuario = "admin";
            final String contrasena = "root2024";
            
            // Inicializar objetos de conexión
            Connection conexion = null;
            Statement declaracion = null;
            ResultSet resultado = null;

            try {
                // Cargar el driver de MySQL
                Class.forName("com.mysql.cj.jdbc.Driver");

                // Establecer la conexión
                conexion = DriverManager.getConnection(url, usuario, contrasena);

                // Crear la declaración SQL
                declaracion = conexion.createStatement();

                // Ejecutar la consulta
                String sql = "SELECT id, nombre, apellido, correo FROM clientes";
                resultado = declaracion.executeQuery(sql);

                // Iterar sobre los resultados
                while (resultado.next()) {
                    int id = resultado.getInt("id");
                    String nombre = resultado.getString("nombre");
                    String apellido = resultado.getString("apellido");
                    String correo = resultado.getString("correo");

                    // Mostrar cada fila en la tabla
                    %>
                    <tr>
                        <td><%= id %></td>
                        <td><%= nombre %></td>
                        <td><%= apellido %></td>
                        <td><%= correo %></td>
                    </tr>
                    <%
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                try {
                    if (resultado != null) resultado.close();
                    if (declaracion != null) declaracion.close();
                    if (conexion != null) conexion.close();
                } catch (SQLException se) {
                    se.printStackTrace();
                }
            }
        %>
    </table>
</body>
</html>
