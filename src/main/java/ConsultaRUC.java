import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

@WebServlet("/ConsultaRUC")
public class ConsultaRUC extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Leer el cuerpo de la solicitud
        StringBuilder sb = new StringBuilder();
        try (BufferedReader reader = request.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        }
        String requestBody = sb.toString();

        // Parsear el cuerpo de la solicitud JSON
        JSONObject jsonRequest = new JSONObject(requestBody);
        String ruc = jsonRequest.getString("rucInput");

        // URL de la API de ruc.com.pe
        String apiUrl = "https://ruc.com.pe/api/v1/consultas";

        // Token de autenticación para la API
        String token = "c4f77f6e-79cd-4151-a3db-73b8ee14dff7-7f390095-5c86-4382-b06d-f3e216163e3b";

        // Crear el cuerpo de la solicitud JSON
        String apiRequestBody = "{ \"token\": \"" + token + "\", \"ruc\": \"" + ruc + "\" }";

        // Realizar la solicitud POST a la API
        URL url = new URL(apiUrl);
        HttpURLConnection con = (HttpURLConnection) url.openConnection();
        con.setRequestMethod("POST");
        con.setRequestProperty("Content-Type", "application/json");
        con.setDoOutput(true);

        // Escribir el cuerpo de la solicitud en el flujo de salida
        try (OutputStream os = con.getOutputStream()) {
            byte[] input = apiRequestBody.getBytes("utf-8");
            os.write(input, 0, input.length);
        }

        // Leer la respuesta de la API
        StringBuilder responseJson = new StringBuilder();
        try (BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream(), "utf-8"))) {
            String responseLine;
            while ((responseLine = br.readLine()) != null) {
                responseJson.append(responseLine.trim());
            }
        }

        // Parsear la respuesta JSON
        String nombreEmpresa = parseNombreEmpresa(responseJson.toString());

        // Construir la respuesta JSON
        JSONObject jsonResponse = new JSONObject();
        jsonResponse.put("nombreEmpresa", nombreEmpresa);

        // Establecer el tipo de contenido de la respuesta y enviar el JSON
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(jsonResponse.toString());
    }

    // Método para extraer el nombre de la empresa desde la respuesta JSON de la API
    private String parseNombreEmpresa(String jsonResponse) {
        String nombreEmpresa = "";
        try {
            // Parsear la respuesta JSON
            JSONObject json = new JSONObject(jsonResponse);
            nombreEmpresa = json.getString("nombre_o_razon_social");
        } catch (JSONException e) {
            // Manejar cualquier error de parsing de JSON
            e.printStackTrace();
            nombreEmpresa = "Error al obtener el nombre de la empresa";
        }
        return nombreEmpresa;
    }
}
