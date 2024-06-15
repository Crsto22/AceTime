<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="jakarta.servlet.http.Cookie" %>
<%@ page import="datos.Mantenimiento" %>
<%@ page import="dao.IMantenimiento" %>
<%
    // Obtener el ID del producto y la cantidad desde el formulario
    int producto_id = Integer.parseInt(request.getParameter("id_producto"));
    int cantidad_nueva = Integer.parseInt(request.getParameter("cantidad"));
    String PagProducto = request.getParameter("PagProducto");

    // Obtener el ID de sesión desde la cookie o generar una nueva si no existe
    String sesion_id = "";
    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (Cookie cookie : cookies) {
            if ("sesion_id".equals(cookie.getName())) {
                sesion_id = cookie.getValue();
                break;
            }
        }
    }
    if (sesion_id.isEmpty()) {
        sesion_id = UUID.randomUUID().toString();
        Cookie sesionCookie = new Cookie("sesion_id", sesion_id);
        sesionCookie.setPath("/");
        response.addCookie(sesionCookie);
    }

    // Obtener el idUsuario de la sesión
    Integer idUsuario = (Integer) session.getAttribute("idUsuario");

    Mantenimiento mantenimiento = new Mantenimiento();
    mantenimiento.conectarBD();
    Connection conn = mantenimiento.getConexion();
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        // Verificar si el producto existe en la base de datos
        String query = "SELECT * FROM Productos WHERE id_producto = ?";
        pstmt = conn.prepareStatement(query);
        pstmt.setInt(1, producto_id);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            int cantidadDisponible = rs.getInt("cantidad");
            double precio = rs.getDouble("precio");

            // Verificar si el producto ya está en el carrito
            if (idUsuario != null) {
                // Si hay un idUsuario en la sesión, usar id_usuario para la consulta
                query = "SELECT cantidad FROM carrito WHERE id_usuario = ? AND id_producto = ?";
                pstmt = conn.prepareStatement(query);
                pstmt.setInt(1, idUsuario);
                pstmt.setInt(2, producto_id);
            } else {
                // Si no hay idUsuario en la sesión, usar sesion_id para la consulta
                query = "SELECT cantidad FROM carrito WHERE sesion_id = ? AND id_producto = ?";
                pstmt = conn.prepareStatement(query);
                pstmt.setString(1, sesion_id);
                pstmt.setInt(2, producto_id);
            }

            ResultSet rsCarrito = pstmt.executeQuery();

            if (rsCarrito.next()) {
                int cantidadExistente = rsCarrito.getInt("cantidad");
                int cantidadTotal = cantidadExistente + cantidad_nueva;

                if (cantidadTotal <= cantidadDisponible) {
                    // Si el producto ya está en el carrito, actualizar la cantidad
                    if (idUsuario != null) {
                        query = "UPDATE carrito SET cantidad = ? WHERE id_usuario = ? AND id_producto = ?";
                        pstmt = conn.prepareStatement(query);
                        pstmt.setInt(1, cantidadTotal);
                        pstmt.setInt(2, idUsuario);
                        pstmt.setInt(3, producto_id);
                    } else {
                        query = "UPDATE carrito SET cantidad = ? WHERE sesion_id = ? AND id_producto = ?";
                        pstmt = conn.prepareStatement(query);
                        pstmt.setInt(1, cantidadTotal);
                        pstmt.setString(2, sesion_id);
                        pstmt.setInt(3, producto_id);
                    }
                    pstmt.executeUpdate();
                    if (PagProducto != null) {
                        response.sendRedirect("producto.jsp?id_producto=" + producto_id + "&mensaje=agregado");
                    } else {
                        response.sendRedirect("productos.jsp?sesion_id=" + sesion_id + "&mensaje=agregado");
                    }
                } else {
                    if (PagProducto != null) {
                        response.sendRedirect("producto.jsp?id_producto=" + producto_id + "&mensaje=insuficiente");
                    } else {
                        response.sendRedirect("productos.jsp?sesion_id=" + sesion_id + "&mensaje=insuficiente");
                    }
                }
            } else {
                // Si el producto no está en el carrito, verificar si la cantidad nueva es menor o igual a la cantidad disponible
                if (cantidad_nueva <= cantidadDisponible) {
                    // Insertar el producto en el carrito
                    if (idUsuario != null) {
                        query = "INSERT INTO carrito (id_usuario, id_producto, cantidad, precio) VALUES (?, ?, ?, ?)";
                        pstmt = conn.prepareStatement(query);
                        pstmt.setInt(1, idUsuario);
                        pstmt.setInt(2, producto_id);
                        pstmt.setInt(3, cantidad_nueva);
                        pstmt.setDouble(4, precio);
                    } else {
                        query = "INSERT INTO carrito (sesion_id, id_producto, cantidad, precio) VALUES (?, ?, ?, ?)";
                        pstmt = conn.prepareStatement(query);
                        pstmt.setString(1, sesion_id);
                        pstmt.setInt(2, producto_id);
                        pstmt.setInt(3, cantidad_nueva);
                        pstmt.setDouble(4, precio);
                    }
                    pstmt.executeUpdate();
                    if (PagProducto != null) {
                        response.sendRedirect("producto.jsp?id_producto=" + producto_id + "&mensaje=agregado");
                    } else {
                        response.sendRedirect("productos.jsp?sesion_id=" + sesion_id + "&mensaje=agregado");
                    }
                } else {
                    if (PagProducto != null) {
                        response.sendRedirect("producto.jsp?id_producto=" + producto_id + "&mensaje=insuficiente");
                    } else {
                        response.sendRedirect("productos.jsp?sesion_id=" + sesion_id + "&mensaje=insuficiente");
                    }
                }
            }
        } else {
            if (PagProducto != null) {
                response.sendRedirect("producto.jsp?id_producto=" + producto_id + "&mensaje=no-encontrado");
            } else {
                response.sendRedirect("productos.jsp?sesion_id=" + sesion_id + "&mensaje=no-encontrado");
            }
        }
    } catch (SQLException e) {
        // Imprimir el error en la página
%>
<h2>Ocurrió un error:</h2>
<%= e.getMessage() %>
<%
    } finally {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        mantenimiento.cerrarBD();
    }
%>
