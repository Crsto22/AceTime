<%@ page import="java.io.File" %>
<%@ page import="java.sql.*" %>
<%@ page import="datos.Mantenimiento" %>

<%
    String idProducto = request.getParameter("id_producto");
    if (idProducto != null && !idProducto.isEmpty()) {
        Mantenimiento mantenimiento = new Mantenimiento();
        try {
            // Establecer la conexi�n con la base de datos utilizando el m�todo conectarBD
            mantenimiento.conectarBD();
            Connection connection = mantenimiento.getConexion();

            // Obtener la URL de la imagen asociada al producto
            String sqlSelect = "SELECT url_imagen FROM Productos WHERE id_producto = ?";
            PreparedStatement selectStmt = connection.prepareStatement(sqlSelect);
            selectStmt.setString(1, idProducto);
            ResultSet rs = selectStmt.executeQuery();
            String urlImagen = null;
            if (rs.next()) {
                urlImagen = rs.getString("url_imagen");
            }

            // Preparar la consulta SQL para eliminar el producto
            String sqlDelete = "DELETE FROM Productos WHERE id_producto = ?";
            PreparedStatement deleteStmt = connection.prepareStatement(sqlDelete);
            deleteStmt.setString(1, idProducto);

            // Ejecutar la consulta para eliminar el producto
            int filasAfectadas = deleteStmt.executeUpdate();
            deleteStmt.close();
            selectStmt.close();

            // Cerrar la conexi�n utilizando el m�todo cerrarBD
            mantenimiento.cerrarBD();

            // Eliminar el archivo de imagen asociado al producto si existe
            if (urlImagen != null) {
                String rutaImagen = getServletContext().getRealPath(urlImagen);
                File archivoImagen = new File(rutaImagen);
                if (archivoImagen.exists()) {
                    archivoImagen.delete();
                }
            }
            // Redireccionar a la p�gina de lista de productos despu�s de eliminar
            response.sendRedirect("panelproductos.jsp");
        } catch (Exception e) {
            // Manejar cualquier excepci�n
            out.println("Error al intentar eliminar el producto: " + e.getMessage());
        } finally {
            // Asegurarse de cerrar la conexi�n en caso de excepci�n
            mantenimiento.cerrarBD();
        }
    } else {
        // Manejar el caso en que no se proporcion� un ID v�lido
        out.println("ID de producto no v�lido.");
    }
%>
