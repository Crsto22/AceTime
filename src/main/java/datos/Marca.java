package datos;

public class Marca {
    private int idMarca;
    private String nombreMarca;
    private String estado;

    // Constructor vacío (puede ser opcional dependiendo de tu caso)
    public Marca() {
    }

    // Constructor con todos los atributos
    public Marca(int idMarca, String nombreMarca, String estado) {
        this.idMarca = idMarca;
        this.nombreMarca = nombreMarca;
        this.estado = estado;
    }

    // Getters y setters
    public int getIdMarca() {
        return idMarca;
    }

    public void setIdMarca(int idMarca) {
        this.idMarca = idMarca;
    }

    public String getNombreMarca() {
        return nombreMarca;
    }

    public void setNombreMarca(String nombreMarca) {
        this.nombreMarca = nombreMarca;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }
}
