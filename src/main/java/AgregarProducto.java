import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
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
public class AgregarProducto extends HttpServlet {

    private static final String RUTA = "/img/relojes/";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Obtener los parámetros del formulario
        String marcaId = req.getParameter("marca");
        String descripcion = req.getParameter("descripcion2");
        String precioStr = req.getParameter("precio2");
        String cantidadStr = req.getParameter("cantidad2");
        String proveedorId = req.getParameter("proveedor");

        // Validar y convertir los valores necesarios
        BigDecimal precio = new BigDecimal(precioStr);
        int cantidad = Integer.parseInt(cantidadStr);

        // Obtener la parte del archivo de imagen
        Part filePart = req.getPart("imagen2");
        String nombreArchivo = filePart.getSubmittedFileName();

        // Ruta completa en el sistema de archivos del servidor
        String rutaWebapp = getServletContext().getRealPath("/");
        String rutaCompleta = rutaWebapp + RUTA;

        // Crear directorio si no existe
        File directorio = new File(rutaCompleta);
        if (!directorio.exists()) {
            directorio.mkdirs();
        }

        // Guardar la imagen en el servidor si se proporciona
        if (nombreArchivo != null && !nombreArchivo.isEmpty()) {
            String rutaArchivo = rutaCompleta + nombreArchivo;
            try (InputStream is = filePart.getInputStream();
                 FileOutputStream fos = new FileOutputStream(rutaArchivo)) {
                byte[] buffer = new byte[1024];
                int bytesLeidos;
                while ((bytesLeidos = is.read(buffer)) != -1) {
                    fos.write(buffer, 0, bytesLeidos);
                }
            }
        }

        // Insertar el producto en la base de datos
        try {
            Mantenimiento mantenimiento = new Mantenimiento();
            mantenimiento.conectarBD();
            Connection conn = mantenimiento.getConexion();

            // Preparar la sentencia SQL para insertar el producto
            String sql = "INSERT INTO Productos (marca_id, proveedor_id, descripcion, precio, cantidad, url_imagen) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, marcaId);
            stmt.setString(2, proveedorId);
            stmt.setString(3, descripcion);
            stmt.setBigDecimal(4, precio);
            stmt.setInt(5, cantidad);
            stmt.setString(6, (nombreArchivo != null && !nombreArchivo.isEmpty()) ? RUTA + nombreArchivo : null);
            stmt.executeUpdate();

            // Cerrar la conexión y redirigir a la página de gestión de productos
            stmt.close();
            mantenimiento.cerrarBD();
            resp.sendRedirect("panelproductos.jsp");

        } catch (SQLException e) {
            // Manejar errores de SQL mostrando un mensaje en la respuesta
            resp.setContentType("text/html");
            resp.setCharacterEncoding("UTF-8");
            resp.getWriter().println("<h1>Error al agregar el producto: " + e.getMessage() + "</h1>");
        }
    }
}
