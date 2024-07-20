import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
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
import com.itextpdf.layout.properties.HorizontalAlignment;
import com.itextpdf.layout.properties.UnitValue;
import com.itextpdf.layout.properties.TextAlignment;
import com.itextpdf.layout.properties.VerticalAlignment;
import jakarta.servlet.annotation.WebServlet;
import datos.Mantenimiento;

@WebServlet("/GeneratePDF")
public class ReporteVentas extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "inline; filename=output.pdf");

        String fechaInicio = request.getParameter("fecha-inicio");
        String fechaFin = request.getParameter("fecha-fin");
        String nombre = request.getParameter("nombre"); // Obtener el nombre

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        LocalDate endDate = LocalDate.parse(fechaFin, formatter);
        LocalDate endDatePlusOne = endDate.plusDays(1);
        String fechaFinIncrementada = endDatePlusOne.format(formatter);

        Mantenimiento mantenimiento = new Mantenimiento();
        mantenimiento.conectarBD();
        Connection conn = mantenimiento.getConexion();

        try (PdfWriter writer = new PdfWriter(response.getOutputStream());
             PdfDocument pdf = new PdfDocument(writer);
             Document document = new Document(pdf)) {

            ImageData imageData = ImageDataFactory.create(getServletContext().getRealPath("/img/ace.png"));
            Image img = new Image(imageData);
            img.setWidth(80);
            img.setHeight(50);

            Table headerTable = new Table(UnitValue.createPercentArray(new float[]{1, 3}));
            headerTable.setWidth(UnitValue.createPercentValue(100));
            headerTable.setBorder(new SolidBorder(1));

            Cell imageCell = new Cell().add(img).setBorder(Border.NO_BORDER);
            headerTable.addCell(imageCell);

            Paragraph companyInfoParagraph = new Paragraph("Razon Social: Ace Time\nRUC: 92312412321\nDireccion: San Juan de Lurigancho\nTelefono: 999921323")
                    .setTextAlignment(TextAlignment.LEFT)
                    .setFontSize(10);
            Cell companyInfoCell = new Cell().add(companyInfoParagraph).setBorder(Border.NO_BORDER).setVerticalAlignment(VerticalAlignment.MIDDLE);
            headerTable.addCell(companyInfoCell);

            document.add(headerTable);

            document.add(new Paragraph("\n"));

            Color tituloColor = new DeviceRgb(255, 0, 0);
            Paragraph titleParagraph = new Paragraph("LISTADO DE VENTAS DESDE " + fechaInicio + " HASTA " + fechaFin)
                    .setTextAlignment(TextAlignment.CENTER)
                    .setBold()
                    .setFontSize(12)
                    .setUnderline()
                    .setFontColor(tituloColor);
            document.add(titleParagraph);

            document.add(new Paragraph("\n"));

            // Modificar la consulta SQL para incluir el filtro por nombre si se proporciona
            String totalQuery = "SELECT SUM(dc.total_compra) AS total_compras_entre_fechas " +
                                "FROM Detalle_Compra dc " +
                                "LEFT JOIN Datos_comprador c ON dc.id_comprador = c.id_comprador " +
                                "LEFT JOIN Usuarios u ON dc.id_usuario = u.id_usuario " +
                                "WHERE dc.fecha_compra >= ? AND dc.fecha_compra < ?";

            if (nombre != null && !nombre.isEmpty()) {
                totalQuery += " AND (c.nombre LIKE ? OR u.nombre LIKE ?)";
            }

            try (PreparedStatement sumStatement = conn.prepareStatement(totalQuery)) {

                sumStatement.setString(1, fechaInicio);
                sumStatement.setString(2, fechaFinIncrementada);

                if (nombre != null && !nombre.isEmpty()) {
                    sumStatement.setString(3, "%" + nombre + "%");
                    sumStatement.setString(4, "%" + nombre + "%");
                }

                try (ResultSet sumResultSet = sumStatement.executeQuery()) {
                    if (sumResultSet.next()) {
                        double totalCompras = sumResultSet.getDouble("total_compras_entre_fechas");

                        Table totalTable = new Table(UnitValue.createPercentArray(new float[]{1, 1}));
                        totalTable.setWidth(UnitValue.createPercentValue(50));
                        totalTable.setBorder(new SolidBorder(1));
                        totalTable.setHorizontalAlignment(HorizontalAlignment.RIGHT);

                        Cell labelCell = new Cell().add(new Paragraph("Total en ventas:"))
                                .setTextAlignment(TextAlignment.RIGHT)
                                .setFontSize(12)
                                .setBold()
                                .setBackgroundColor(new DeviceRgb(255, 228, 196))
                                .setBorder(new SolidBorder(1));
                        totalTable.addCell(labelCell);

                        Cell totalCell = new Cell().add(new Paragraph(String.valueOf("S/ " + totalCompras)))
                                .setTextAlignment(TextAlignment.RIGHT)
                                .setFontSize(12)
                                .setBold()
                                .setBackgroundColor(new DeviceRgb(255, 228, 196))
                                .setBorder(new SolidBorder(1));
                        totalTable.addCell(totalCell);

                        document.add(totalTable);
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
                document.add(new Paragraph("Error al obtener el total de ventas: " + e.getMessage()));
            }

            document.add(new Paragraph("\n"));

            String dataQuery = "SELECT dc.id_compra, c.nombre AS nombre_comprador, c.apellido AS apellido_comprador, c.Num_Documento AS num_doc_comprador, " +
                               "dc.total_compra, dc.fecha_compra, u.nombre AS nombre_cliente, u.apellido AS apellido_cliente, u.Num_Documento AS num_doc_cliente " +
                               "FROM Detalle_Compra dc " +
                               "LEFT JOIN Datos_comprador c ON dc.id_comprador = c.id_comprador " +
                               "LEFT JOIN Usuarios u ON dc.id_usuario = u.id_usuario " +
                               "WHERE dc.fecha_compra >= ? AND dc.fecha_compra < ?";

            if (nombre != null && !nombre.isEmpty()) {
                dataQuery += " AND (c.nombre LIKE ? OR u.nombre LIKE ?)";
            }

            try (PreparedStatement preparedStatement = conn.prepareStatement(dataQuery)) {
                preparedStatement.setString(1, fechaInicio);
                preparedStatement.setString(2, fechaFinIncrementada);

                if (nombre != null && !nombre.isEmpty()) {
                    preparedStatement.setString(3, "%" + nombre + "%");
                    preparedStatement.setString(4, "%" + nombre + "%");
                }

                try (ResultSet resultSet = preparedStatement.executeQuery()) {
                    Table table = new Table(UnitValue.createPercentArray(new float[]{1, 2, 3, 2, 1, 2}));
                    table.setWidth(UnitValue.createPercentValue(100));

                    Color headerColor = new DeviceRgb(250, 173, 28);
                    Color rowColor = new DeviceRgb(255, 255, 255);
                    table.addHeaderCell(new Cell().add(new Paragraph("ID")).setBackgroundColor(headerColor).setFontColor(rowColor));
                    table.addHeaderCell(new Cell().add(new Paragraph("NOMBRE")).setBackgroundColor(headerColor).setFontColor(rowColor));
                    table.addHeaderCell(new Cell().add(new Paragraph("APELLIDO")).setBackgroundColor(headerColor).setFontColor(rowColor));
                    table.addHeaderCell(new Cell().add(new Paragraph("DOCUMENTO")).setBackgroundColor(headerColor).setFontColor(rowColor));
                    table.addHeaderCell(new Cell().add(new Paragraph("TOTAL COMPRA")).setBackgroundColor(headerColor).setFontColor(rowColor));
                    table.addHeaderCell(new Cell().add(new Paragraph("FECHA COMPRA")).setBackgroundColor(headerColor).setFontColor(rowColor));

                    while (resultSet.next()) {
                        table.addCell(resultSet.getString("id_compra"));

                        String nombreComprador = resultSet.getString("nombre_comprador") != null ? resultSet.getString("nombre_comprador") : resultSet.getString("nombre_cliente");
                        String apellido = resultSet.getString("apellido_comprador") != null ? resultSet.getString("apellido_comprador") : resultSet.getString("apellido_cliente");
                        String documento = resultSet.getString("num_doc_comprador") != null ? resultSet.getString("num_doc_comprador") : resultSet.getString("num_doc_cliente");

                        table.addCell(nombreComprador);
                        table.addCell(apellido);
                        table.addCell(documento);
                        table.addCell(resultSet.getString("total_compra"));
                        table.addCell(resultSet.getString("fecha_compra"));
                    }

                    document.add(table);
                }
            } catch (Exception e) {
                e.printStackTrace();
                document.add(new Paragraph("Error al obtener datos: " + e.getMessage()));
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error al generar el PDF: " + e.getMessage());
        } finally {
            mantenimiento.cerrarBD();
        }
    }
}
