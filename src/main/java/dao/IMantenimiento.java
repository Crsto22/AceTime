
package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public interface IMantenimiento {
    public void conectarBD();
    public void cerrarBD();
   
}