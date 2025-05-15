/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.apro.db;

import java.sql.*;

/**
 *
 * @author paula
 */
public class ConectorDB {
    
    private static String url_BD = "jdbc:mariadb://localhost:3360/negocio",
            usuario_BD = "root",
            contrasena_BD = "admin";

    //1.
    public static void cargarDriver_BD(String driver_PARAM){
        try {
            Class.forName(driver_PARAM);
        } catch (ClassNotFoundException e) {
            System.err.println("No se encontró el driver MariaDB: " + e.getMessage());
            return;
        }
    }
    
    //2.
    public static void modificarURL_BD(String url_PARAM, String usuario_PARAM, String contrasena_PARAM){
        url_BD = url_PARAM;
        usuario_BD = usuario_PARAM;
        contrasena_BD = contrasena_PARAM;
    }
    
    //3.
    public static Connection crearConexion_BD(){
        try{
            return DriverManager.getConnection(url_BD, usuario_BD, contrasena_BD);
        } catch (SQLException e) {
            System.err.println("Error en la conexión o consulta: " + e.getMessage());
            return null;
        }
    }
    
    //4.
    public static ResultSet consultar_BD(String consulta_PARAM, Connection conexion_PARAM){
        try{
            Statement statement_CON = conexion_PARAM.createStatement();
            return statement_CON.executeQuery(consulta_PARAM);
        } catch (SQLException e) {
            System.err.println("Error en la conexión o consulta: " + e.getMessage());
            return null;
        }
    }
    
    public static int accion_BD(String consulta_PARAM, Connection conexion_PARAM){
        try{
            Statement statement_CON = conexion_PARAM.createStatement();
            return statement_CON.executeUpdate(consulta_PARAM);
        }catch (SQLException e) {
            System.err.println("Error en la conexión o consulta: " + e.getMessage());
            return -1;
        }
    }
    
    /*
    public static void main(String[] args) {
    
        //1. Cargar driver.
        cargarDriver_BD("org.mariadb.jdbc.Driver");

        // 3. Crear la conexión
        try (Connection conexion = crearConexion_BD()) {
            // 4. Ejecutar una consulta (ejemplo)
            ResultSet resultado = consultar_BD("SELECT * FROM producto",conexion);

            // 5. Procesar los resultados (ejemplo)
            while (resultado.next()) {
                System.out.println(resultado.getString(1) + " - " + resultado.getString(2));
            }
            
            String sql2 = "insert into producto (n_v_nom,d_v_desc,f_t_fecha) values (\"printer\",\"HP Probook\",\"2025-05-25\");";
            int insertar = insertar_BD(sql2,conexion);
            
            if(insertar > 0){
                            System.out.println("exito registro");
            }
            
            // 6. Cerrar la conexión (no necesario con try-with-resources)
            // Forma moderna y segura de manejar recursos como Connection, Statement, y ResultSet. 
            // conexion.close();
        } catch (SQLException e) {
            System.err.println("Error en la conexión o consulta: " + e.getMessage());
        }
    }*/
}