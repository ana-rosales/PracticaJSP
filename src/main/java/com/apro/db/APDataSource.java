/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.apro.db;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.SQLFeatureNotSupportedException;
import java.util.Properties;
import java.util.logging.Logger;
import javax.sql.DataSource;

/**
 * Una sola conexion para un data source específico.
 * @author paula
 */
public class APDataSource implements DataSource{
    
    /**
     * Conexion a este DataSource.
     */
    private Connection con_BD;
    
    /**
     * Información de la conexion.
     */
    private String usu_DS, pwd_DS, driver_DS, url_DS;
    
    /**
     * Objeto properties con configuracion.
     */
    private Properties prop_DS;
    
    /**
     * Constructor para data source.
     */
    public APDataSource (){
        
    }
    
    /**
     * MIS METODOS.
     */
    
    /**
     * Carga el driver.
     */
    public synchronized void loadDriver(){
        try {
            Class.forName(this.driver_DS);
        } catch (ClassNotFoundException e) {
            System.err.println("No se encontró el driver: " + e.getMessage());
        }
    }
    
    /**
     * Obtiene el archivo que almacena las propiedades de
     * configuracion del DataSource.
     * 
     * @param file_PARAM
     * @throws IOException 
     */
    public synchronized void setProperties(String file_PARAM) throws IOException{
        try(
            FileInputStream in_PROP = new FileInputStream(file_PARAM)
        ){
            this.prop_DS = new Properties();
            this.prop_DS.load(in_PROP);
            this.usu_DS = this.prop_DS.getProperty("usu");
            this.pwd_DS = this.prop_DS.getProperty("pwd");
            this.driver_DS = this.prop_DS.getProperty("driver");
            this.url_DS = this.prop_DS.getProperty("url");
        } catch (IOException ioe){
            throw new IOException(ioe);
        }
        
    }
    
    /**
     * Crea la conexion con DriverManager.
     * 
     * @throws SQLException 
     */
    public synchronized void createConnection() throws SQLException{
        if(this.usu_DS == "" && this.pwd_DS == ""){
            this.con_BD = DriverManager.getConnection(this.url_DS);
        } else {
            this.con_BD = DriverManager.getConnection(this.url_DS, this.usu_DS, this.pwd_DS);
        }
        System.out.println("---- Conexion establecida ----");
    }
    
    /**
     * Cierra la conexion.
     */
    public void closeConnection() throws SQLException {
        this.con_BD.close();
    }
    
    /**
     * METODOS DE DATA SOURCE.
     */
    
    /**
     * Devuelve la conexion a este data source.
     * 
     * @return con_BD (Connection)
     * @throws SQLException 
     */
    @Override
    public synchronized Connection getConnection() {
        return this.con_BD;
    }
    
    /**
     * METODOS NO IMPLEMENTADOS.
     */
    
    @Override
    public Connection getConnection(String username, String password) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public PrintWriter getLogWriter() throws SQLException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public void setLogWriter(PrintWriter out) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public void setLoginTimeout(int seconds) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public int getLoginTimeout() throws SQLException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public Logger getParentLogger() throws SQLFeatureNotSupportedException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public <T> T unwrap(Class<T> iface) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean isWrapperFor(Class<?> iface) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
    
}
