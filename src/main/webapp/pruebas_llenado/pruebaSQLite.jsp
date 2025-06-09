<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    try {
        Class.forName("org.sqlite.JDBC");
        System.out.println("Driver cargado exitosamente.");
    } catch (ClassNotFoundException e) {
        System.err.println("No se encontró el driver: " + e.getMessage());
    }
    
    try(
        Connection con =  DriverManager.getConnection("jdbc:sqlite:C:/sqlite/db/prueba_jee8.db");
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("select * from c_usuario;");
    ){
        System.out.println("Exito conexion");
        boolean hayUsu = false;
        while(rs.next()){
            hayUsu = true;
            System.out.println(rs.getString(1) + " | " + rs.getString(2));
        }
        if(!hayUsu){
            System.out.println("No hay usuarios");
        }
    } catch (SQLException e){
        System.out.println("Error conexion: " + e);
    }

%>