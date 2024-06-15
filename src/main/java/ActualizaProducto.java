import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import datos.Mantenimiento;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@MultipartConfig(fileSizeThreshold = 1024 * 1024,
        maxFileSize = 1024 * 1024 * 5,
        maxRequestSize = 1024 * 1024 * 5 * 5)
public class ActualizaProducto extends HttpServlet {

    private static final String RUTA = "/img/relojes/";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        
        
        String idProducto = req.getParameter("id_producto");
        String marca = req.getParameter("marca");
        String descripcion = req.getParameter("descripcion");
        String proveedor = req.getParameter("proveedor");
        String precio = req.getParameter("precio");
        String cantidad = req.getParameter("cantidad");

        Part filePart = req.getPart("imagen");
        String nombreArchivo = null;
        if (filePart != null && filePart.getSize() > 0) {
            nombreArchivo = filePart.getSubmittedFileName();
        }

        String rutaWebapp = getServletContext().getRealPath("/");
        String rutaCompleta = rutaWebapp + RUTA;

        File directorio = new File(rutaCompleta);
        if (!directorio.exists()) {
            directorio.mkdirs();
        }
        if (descripcion != null) {
            descripcion = descripcion.trim().replaceAll("\\s+", " ");
        }
        try {
            // Crear una instancia de la clase Mantenimiento para manejar la conexión a la base de datos
            Mantenimiento mantenimiento = new Mantenimiento();
            mantenimiento.conectarBD();
            Connection conn = mantenimiento.getConexion();

            // Consultar la URL de la imagen actual del producto
            PreparedStatement selectStmt = conn.prepareStatement("SELECT url_imagen FROM Productos WHERE id_producto=?");
            selectStmt.setInt(1, Integer.parseInt(idProducto));
            ResultSet rs = selectStmt.executeQuery();
            String urlImagenActual = null;
            if (rs.next()) {
                urlImagenActual = rs.getString("url_imagen");
            }

            // Determinar la URL de la imagen (nueva o la misma)
            String urlImagen = (nombreArchivo != null) ? RUTA + nombreArchivo : urlImagenActual;

            // Guardar la nueva imagen si se proporciona
            if (nombreArchivo != null) {
                String rutaArchivo = rutaCompleta + nombreArchivo;
                File fichero = new File(rutaArchivo);

                try (FileOutputStream fos = new FileOutputStream(fichero)) {
                    InputStream is = filePart.getInputStream();
                    byte[] buffer = new byte[1024];
                    int bytesLeidos;
                    while ((bytesLeidos = is.read(buffer)) != -1) {
                        fos.write(buffer, 0, bytesLeidos);
                    }
                }
            }

            // Actualizar los datos del producto en la base de datos
            PreparedStatement updateStmt = conn.prepareStatement("UPDATE Productos SET marca_id=?, descripcion=?, precio=?, cantidad=?, url_imagen=?, proveedor_id=? WHERE id_producto=?");
            updateStmt.setString(1, marca);
            updateStmt.setString(2, descripcion);
            updateStmt.setBigDecimal(3, new BigDecimal(precio));
            updateStmt.setInt(4, Integer.parseInt(cantidad));
            updateStmt.setString(5, urlImagen);
            updateStmt.setString(6, proveedor);
            updateStmt.setInt(7, Integer.parseInt(idProducto));
            updateStmt.executeUpdate();

            // Cerrar la conexión a la base de datos
            mantenimiento.cerrarBD();

            // Redirigir a la página de gestión de productos
            resp.sendRedirect("panelproductos.jsp");

        } catch (SQLException e) {
            // Manejar errores de SQL mostrando un mensaje en la respuesta
            resp.setContentType("text/html");
            resp.setCharacterEncoding("UTF-8");
            resp.getWriter().println("<h1>Error al actualizar el producto: " + e.getMessage() + "</h1>");
        }
    }
}
