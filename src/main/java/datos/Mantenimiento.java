package datos;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import datos.Marca; // Asegúrate de importar la clase Marca aquí

public class Mantenimiento {

    private Connection conexion;
    private final String url = "jdbc:mysql://localhost:3308/AceTime";
    private final String usuario = "root";
    private final String contrasena = "root";

    public void conectarBD() {
        try {
            conexion = DriverManager.getConnection(url, usuario, contrasena);
            System.out.println("Conexión exitosa a la base de datos.");
        } catch (SQLException ex) {
            System.out.println("Error al conectar a la base de datos: " + ex.getMessage());
        }
    }

    public void cerrarBD() {
        if (conexion != null) {
            try {
                conexion.close();
                System.out.println("Conexión cerrada.");
            } catch (SQLException ex) {
                System.out.println("Error al cerrar la conexión: " + ex.getMessage());
            }
        }
    }

    public List<Marca> obtenerMarcas() {
        List<Marca> marcas = new ArrayList<>();
        String consulta = "SELECT id_marca, nombre_marca, estado FROM Marca WHERE estado = 'disponible'";

        try {
            conectarBD();
            PreparedStatement statement = conexion.prepareStatement(consulta);
            ResultSet resultado = statement.executeQuery();

            while (resultado.next()) {
                int idMarca = resultado.getInt("id_marca");
                String nombreMarca = resultado.getString("nombre_marca");
                String estado = resultado.getString("estado");

                Marca marca = new Marca(idMarca, nombreMarca, estado);
                marcas.add(marca);
            }

            resultado.close();
            statement.close();
            cerrarBD();

        } catch (SQLException ex) {
            System.out.println("Error al obtener marcas: " + ex.getMessage());
        }

        return marcas;
    }

    public List<Proveedor> obtenerProveedores() {
        List<Proveedor> proveedores = new ArrayList<>();
        String consulta = "SELECT id_proveedor, nombre_proveedor FROM Proveedores WHERE estado = 'disponible'";

        try {
            conectarBD();
            PreparedStatement statement = conexion.prepareStatement(consulta);
            ResultSet resultado = statement.executeQuery();

            while (resultado.next()) {
                int idProveedor = resultado.getInt("id_proveedor");
                String nombreProveedor = resultado.getString("nombre_proveedor");

                Proveedor proveedor = new Proveedor(idProveedor, nombreProveedor);
                proveedores.add(proveedor);
            }

            statement.close();
            cerrarBD();

        } catch (SQLException ex) {
            System.out.println("Error al obtener proveedores: " + ex.getMessage());
        }

        return proveedores;
    }

    public Connection getConexion() {
        return conexion;
    }
}
