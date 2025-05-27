/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.apro.db;

import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.SQLFeatureNotSupportedException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;
import javax.sql.DataSource;

/**
 *
 * @author paula
 */
public class APDataSource implements DataSource{
    
    /**
     * Pool de conexiones de este DataSource.
     */
    private final List<APConnection> pool_DS = new ArrayList<>();
    
    /**
     * Información del DataSource.
     */
    private String usu_DS, pwd_DS, base_DS, driver_DS, url_DS;
    
    /**
     * Cantidad de conexiones iniciales en el pool.
     */
    private int ini_CON = 3;
    
    /**
     * Maximo de conexiones que se pueden guardar en el pool.
     */
    private int maxIdl_CON = 5;
    
    /**
     * Maximo de conexiones que se pueden prestar.
     */
    private int maxBrw_CON = 5;
    
    /**
     * Conexiones prestadas.
     */
    private int brw_CON;
    
    /**
     * Tiempo que espera un Thread a que se libere una conexion.
     * Predeterminado 10 seg en milisegundos.
     */
    private long espera_CON = 10000;
    
    /**
     * Veces que se puede prestar una conexion.
     */
    private int vidas_CON = 2;
    
    /**
     * Constructor vacio para no cargar objeto.
     * @throws SQLException
     */
    public APDataSource (){
        
    }
    
    /**
     * SETTERS Y GETTERS.
     */

    public int getMaxBrw_CON() {
        return maxBrw_CON;
    }

    public void setMaxBrw_CON(int maxBrw_CON) {
        this.maxBrw_CON = maxBrw_CON;
    }

    public int getBrw_CON() {
        return brw_CON;
    }

    public void setBrw_CON(int brw_CON) {
        this.brw_CON = brw_CON;
    }

    public long getEspera_CON() {
        return espera_CON;
    }

    public void setEspera_CON(long espera_CON) {
        this.espera_CON = espera_CON;
    }

    public int getVidas_CON() {
        return vidas_CON;
    }

    public void setVidas_CON(int vidas_CON) {
        this.vidas_CON = vidas_CON;
    }

    public String getUsu_DS() {
        return usu_DS;
    }

    public void setUsu_DS(String usu_DS) {
        this.usu_DS = usu_DS;
    }

    public String getPwd_DS() {
        return pwd_DS;
    }

    public void setPwd_DS(String pwd_DS) {
        this.pwd_DS = pwd_DS;
    }

    public String getBase_DS() {
        return base_DS;
    }

    public void setBase_DS(String base_DS) {
        this.base_DS = base_DS;
    }

    public String getDriver_DS() {
        return driver_DS;
    }

    public void setDriver_DS(String driver_DS) {
        this.driver_DS = driver_DS;
    }

    public String getUrl_DS() {
        return url_DS;
    }

    public void setUrl_DS(String url_DS) {
        this.url_DS = url_DS;
    }

    public int getIni_CON() {
        return ini_CON;
    }

    public void setIni_CON(int ini_CON) {
        this.ini_CON = ini_CON;
    }

    public int getMaxIdl_CON() {
        return maxIdl_CON;
    }

    public void setMaxIdl_CON(int maxIdl_CON) {
        this.maxIdl_CON = maxIdl_CON;
    }
    
    /**
     * MIS METODOS.
     */
    
    /**
     * Metodo para cargar el driver indicado.
     */
    public void loadDriver(){
        try {
            Class.forName(driver_DS);
        } catch (ClassNotFoundException e) {
            System.err.println("No se encontró el driver MariaDB: " + e.getMessage());
            return;
        }
    }
    
    /**
     * Se guarda cierta cantidad de conexiones iniciales en el pool. 
     * Al instanciar el DataSource.
     * 
     * @throws SQLException 
     */
    public void init() throws SQLException {
        for(int i = 0; i < ini_CON; i++){
            this.getConnection();
        }
        brw_CON = 0;
    }
    
    /**
     * Devolver la conexion al pool.
     * @param con_PARAM 
     */
    public void releaseConnection(APConnection wrp_PARAM){
        this.pool_DS.add(wrp_PARAM);
    }
    
    /**
     * Devolver la cantidad de conexiones guardadas en el pool de este 
     * DataSource.
     * @return size de list pool_DS.
     */
    public int getSize(){
        return this.pool_DS.size();
    }
    
    /**
     * METODOS DE DATA SOURCE.
     */
    
    /**
     * Busca una conexion en el pool de este DataSource. 
     * 
     * Si no hay o aun no se llena el pool, crea una nueva conexion con 
     * DriverManager, almacena la conexion en un envoltorio que se guarda
     * en el pool.
     * 
     * Si existe una conexion y aun no se pasa el limite de conexiones 
     * prestadas, la trae y disminuye la vida de la conexion.
     * 
     * Si se pasó el limite de conexiones, se espera el valor de espera_CON a
     * que se libere alguna conexion, si no se libera, lanza un error.
     * 
     * @return
     * @throws SQLException 
     */
    @Override
    public APConnection getConnection() throws SQLException {
        
        /**
         * Crea una nueva conexion si está vacío o si aun no se llena el pool.
         */
        if(pool_DS.isEmpty() || pool_DS.size() < this.maxIdl_CON){
            Connection con_BD = DriverManager.getConnection(url_DS, usu_DS, pwd_DS);
            
            APConnection wrp_CON = new APConnection();
            wrp_CON.setVal_CON(con_BD);
            wrp_CON.setDs_CON(this);
            wrp_CON.setVidas_CON(this.vidas_CON);
            wrp_CON.setEdo_CON(false);
            
            pool_DS.add(wrp_CON);
        }
        
        /**
         * Si el maximo de prestadas de cumple, el hilo tiene que esperar el
         * tiempo de espera_CON a que se libere una conexion.
         */
        synchronized (this) {
            long ini_ESP = System.currentTimeMillis();
            long restante_ESP = espera_CON;

            while (brw_CON >= maxBrw_CON && restante_ESP > 0) {
                try {
                    wait(restante_ESP);
                } catch (InterruptedException ex) {
                    Thread.currentThread().interrupt();
                    throw new SQLException("Interrumpido mientras esperaba una conexión disponible.");
                }
                restante_ESP = espera_CON - (System.currentTimeMillis() - ini_ESP);
            }
        }
        
        /**
        * Verificar cantidad maxima de prestadas. Si aun no se llega se presta,
        * si no espera y lanza error.
        */
        if(this.brw_CON < this.maxBrw_CON){
            APConnection wrp_CON = pool_DS.remove(pool_DS.size()-1);
            wrp_CON.setVidas_CON(wrp_CON.getVidas_CON() - 1);
            wrp_CON.setEdo_CON(true);
            this.brw_CON = this.brw_CON + 1;
            return wrp_CON;
        } else {
            throw new SQLException("Tiempo de espera agotado. No hay conexiones disponibles.");
        }
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
