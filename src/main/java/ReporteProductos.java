import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.itextpdf.kernel.colors.Color;
import com.itextpdf.kernel.colors.DeviceRgb;
import com.itextpdf.kernel.pdf.*;
import com.itextpdf.layout.*;
import com.itextpdf.layout.element.*;
import com.itextpdf.io.image.ImageData;
import com.itextpdf.io.image.ImageDataFactory;
import com.itextpdf.layout.borders.Border;
import com.itextpdf.layout.borders.SolidBorder;
import com.itextpdf.layout.properties.UnitValue;
import com.itextpdf.layout.properties.TextAlignment;
import com.itextpdf.layout.properties.VerticalAlignment;
import jakarta.servlet.annotation.WebServlet;

@WebServlet("/GeneratePDF")
public class ReporteProductos extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "inline; filename=output.pdf");

        String brandParam = request.getParameter("brand");
        int idMarca = -1; // Valor por defecto para obtener todos los productos

        // Determinar la id_marca seleccionada
        if (brandParam != null && !brandParam.isEmpty() && !brandParam.equals("todos")) {
            try {
                idMarca = Integer.parseInt(brandParam);
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        try (PdfWriter writer = new PdfWriter(response.getOutputStream());
             PdfDocument pdf = new PdfDocument(writer);
             Document document = new Document(pdf)) {

            // Agregar la imagen (logo)
            ImageData imageData = ImageDataFactory.create(getServletContext().getRealPath("/img/ace.png"));
            Image img = new Image(imageData);
            img.setWidth(80);  // Ajustar el tamaño de la imagen
            img.setHeight(50);  // Ajustar el tamaño de la imagen

            // Crear una tabla para el encabezado con imagen y datos de la empresa
            Table headerTable = new Table(UnitValue.createPercentArray(new float[]{1, 3}));
            headerTable.setWidth(UnitValue.createPercentValue(100));
            headerTable.setBorder(new SolidBorder(1));

            // Celda para la imagen
            Cell imageCell = new Cell().add(img).setBorder(Border.NO_BORDER);
            headerTable.addCell(imageCell);

            // Celda para los datos de la empresa
            Paragraph companyInfoParagraph = new Paragraph("Razon Social: Ace Time\nRUC: 92312412321\nDireccion: San Juan de Lurigancho\nTelefono: 999921323")
                    .setTextAlignment(TextAlignment.LEFT)
                    .setFontSize(10);
            Cell companyInfoCell = new Cell().add(companyInfoParagraph).setBorder(Border.NO_BORDER).setVerticalAlignment(VerticalAlignment.MIDDLE);
            headerTable.addCell(companyInfoCell);

            // Agregar la tabla del encabezado al documento
            document.add(headerTable);

            // Agregar espacio entre el encabezado y el título
            document.add(new Paragraph("\n"));

            // Colores
            Color headerColor = new DeviceRgb(250, 173, 28);
            Color rowColor = new DeviceRgb(255, 255, 255);
            Color tituloColor = new DeviceRgb(255, 0, 0);

            // Título del listado de productos
            Paragraph titleParagraph = new Paragraph("LISTADO DE PRODUCTOS")
                    .setTextAlignment(TextAlignment.CENTER)
                    .setBold()
                    .setFontSize(12)
                    .setUnderline()
                    .setFontColor(tituloColor);
            document.add(titleParagraph);

            // Agregar espacio entre el título y la tabla
            document.add(new Paragraph("\n"));

            // Crear una tabla
            Table table = new Table(UnitValue.createPercentArray(new float[]{1, 2, 3, 2, 1, 2}));
            table.setWidth(UnitValue.createPercentValue(100));

            // Añadir encabezado a la tabla con color
            table.addHeaderCell(new Cell().add(new Paragraph("ID")).setBackgroundColor(headerColor).setFontColor(rowColor));
            table.addHeaderCell(new Cell().add(new Paragraph("MARCA")).setBackgroundColor(headerColor).setFontColor(rowColor));
            table.addHeaderCell(new Cell().add(new Paragraph("DESCRIPCION")).setBackgroundColor(headerColor).setFontColor(rowColor));
            table.addHeaderCell(new Cell().add(new Paragraph("PRECIO")).setBackgroundColor(headerColor).setFontColor(rowColor));
            table.addHeaderCell(new Cell().add(new Paragraph("CANTIDAD")).setBackgroundColor(headerColor).setFontColor(rowColor));
            table.addHeaderCell(new Cell().add(new Paragraph("PROVEEDOR")).setBackgroundColor(headerColor).setFontColor(rowColor));

            // Conectar a la base de datos y obtener datos filtrados por marca si no se selecciona "todos"
            try (Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3308/AceTime", "root", "root");
                 PreparedStatement preparedStatement = connection.prepareStatement("SELECT pr.id_producto, m.nombre_marca AS marca_producto, pr.descripcion, pr.precio, pr.cantidad, pv.nombre_proveedor FROM Productos pr INNER JOIN Marca m ON pr.marca_id = m.id_marca INNER JOIN Proveedores pv ON pr.proveedor_id = pv.id_proveedor WHERE (? = -1 OR m.id_marca = ?)")) {

                // Configurar parámetro de la marca
                preparedStatement.setInt(1, idMarca); // Primer ? para el caso de todos (-1)
                preparedStatement.setInt(2, idMarca); // Segundo ? para la id_marca específica

                // Ejecutar la consulta
                try (ResultSet resultSet = preparedStatement.executeQuery()) {
                    // Rellenar la tabla con los datos obtenidos
                    while (resultSet.next()) {
                        table.addCell(resultSet.getString("id_producto"));
                        table.addCell(resultSet.getString("marca_producto"));
                        table.addCell(resultSet.getString("descripcion"));
                        table.addCell(resultSet.getString("precio"));
                        table.addCell(resultSet.getString("cantidad"));
                        table.addCell(resultSet.getString("nombre_proveedor"));
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
                document.add(new Paragraph("Error al obtener datos: " + e.getMessage()));
            }

            // Añadir la tabla al documento
            document.add(table);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error al generar el PDF: " + e.getMessage());
        }
    }
}
