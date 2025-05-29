/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.apro.db;

import java.sql.Array;
import java.sql.Blob;
import java.sql.CallableStatement;
import java.sql.Clob;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.NClob;
import java.sql.PreparedStatement;
import java.sql.SQLClientInfoException;
import java.sql.SQLException;
import java.sql.SQLWarning;
import java.sql.SQLXML;
import java.sql.Savepoint;
import java.sql.Statement;
import java.sql.Struct;
import java.util.Map;
import java.util.Properties;
import java.util.concurrent.Executor;

/**
 *
 * @author paula
 */
public class APConnection implements Connection {
    
    /**
     * Valor de la conexion real.
     */
    private Connection val_CON;
    
    
    /**
     * Información del DataSource al que pertenece la conexion.
     */
    private APDataSource ds_CON;
    
    /**
     * Veces que se puede prestar la conexion.
     */
    private int vidas_CON;
    
    /**
     * Estado de la conexion.
     */
    private boolean edo_CON;
    
    /**
     * Constructor vacio para no sobrecargar al objeto.
     */
    public APConnection(){
        
    }

    /**
     * Setters y Getters.
     */
    
    public Connection getVal_CON() {
        return val_CON;
    }

    public APDataSource getDs_CON() {
        return ds_CON;
    }

    public void setDs_CON(APDataSource ds_CON) {
        this.ds_CON = ds_CON;
    }

    public void setVal_CON(Connection val_CON) {
        this.val_CON = val_CON;
    }

    public int getVidas_CON() {
        return vidas_CON;
    }

    public void setVidas_CON(int vidas_CON) {
        this.vidas_CON = vidas_CON;
    }

    public boolean isEdo_CON() {
        return edo_CON;
    }

    public void setEdo_CON(boolean edo_CON) {
        this.edo_CON = edo_CON;
    }
    
    /**
     * Devuelve la conexion al pool de conexiones.
     * Si la conexion se ha usado mas veces de las posibles, se cierra por completo.
     * 
     * @throws SQLException 
     */
    @Override
    public synchronized void close() throws SQLException {
        if(this.isEdo_CON()){
            /**
            * Devuelve al pool si el pool aun no está lleno y si la conexion aun
            * tiene vidas disponibles. Si no la cierra.
            */
           if(ds_CON.getSize() < ds_CON.getMaxIdl_CON() && this.vidas_CON > 0){
               this.edo_CON = false;
               ds_CON.releaseConnection(this);

               /**
               * Cuando se libere una conexion se notifica a los hilos que esperan
               * en ds_CON.
               */

           } else {
               val_CON.close();
           }

           /**
            * Se resta una conexion a las conexiones prestadas del DataSource.
            */
           ds_CON.setBrw_CON(ds_CON.getBrw_CON() - 1);
           
           synchronized (ds_CON) {
               ds_CON.notifyAll();
           }
        }
    }
    
    /**
     * METODOS CONNECTION.
     */

    @Override
    public Statement createStatement() throws SQLException {
        return val_CON.createStatement();
    }

    @Override
    public PreparedStatement prepareStatement(String sql) throws SQLException {
        return val_CON.prepareStatement(sql);
    }

    @Override
    public CallableStatement prepareCall(String sql) throws SQLException {
        return val_CON.prepareCall(sql);
    }

    @Override
    public String nativeSQL(String sql) throws SQLException {
        return val_CON.nativeSQL(sql);
    }

    @Override
    public void setAutoCommit(boolean autoCommit) throws SQLException {
        val_CON.setAutoCommit(autoCommit);
    }

    @Override
    public boolean getAutoCommit() throws SQLException {
        return val_CON.getAutoCommit();
    }

    @Override
    public void commit() throws SQLException {
        val_CON.commit();
    }

    @Override
    public void rollback() throws SQLException {
        val_CON.rollback();
    }

    @Override
    public boolean isClosed() throws SQLException {
        return val_CON.isClosed();
    }

    @Override
    public DatabaseMetaData getMetaData() throws SQLException {
        return val_CON.getMetaData();
    }

    @Override
    public void setReadOnly(boolean readOnly) throws SQLException {
        val_CON.setReadOnly(readOnly);
    }

    @Override
    public boolean isReadOnly() throws SQLException {
        return val_CON.isReadOnly();
    }

    @Override
    public void setCatalog(String catalog) throws SQLException {
        val_CON.setCatalog(catalog);
    }

    @Override
    public String getCatalog() throws SQLException {
        return val_CON.getCatalog();
    }

    @Override
    public void setTransactionIsolation(int level) throws SQLException {
        val_CON.setTransactionIsolation(level);
    }

    @Override
    public int getTransactionIsolation() throws SQLException {
        return val_CON.getTransactionIsolation();
    }

    @Override
    public SQLWarning getWarnings() throws SQLException {
        return val_CON.getWarnings();
    }

    @Override
    public void clearWarnings() throws SQLException {
        val_CON.clearWarnings();
    }

    @Override
    public Statement createStatement(int resultSetType, int resultSetConcurrency) throws SQLException {
        return val_CON.createStatement(resultSetType, resultSetConcurrency);
    }

    @Override
    public PreparedStatement prepareStatement(String sql, int resultSetType, int resultSetConcurrency) throws SQLException {
        return val_CON.prepareStatement(sql, resultSetType, resultSetConcurrency);
    }

    @Override
    public CallableStatement prepareCall(String sql, int resultSetType, int resultSetConcurrency) throws SQLException {
        return val_CON.prepareCall(sql, resultSetType, resultSetConcurrency);
    }

    @Override
    public Map<String, Class<?>> getTypeMap() throws SQLException {
        return val_CON.getTypeMap();
    }

    @Override
    public void setTypeMap(Map<String, Class<?>> map) throws SQLException {
        val_CON.setTypeMap(map);
    }

    @Override
    public void setHoldability(int holdability) throws SQLException {
        val_CON.setHoldability(holdability);
    }

    @Override
    public int getHoldability() throws SQLException {
        return val_CON.getHoldability();
    }

    @Override
    public Savepoint setSavepoint() throws SQLException {
        return val_CON.setSavepoint();
    }

    @Override
    public Savepoint setSavepoint(String name) throws SQLException {
        return val_CON.setSavepoint(name);
    }

    @Override
    public void rollback(Savepoint savepoint) throws SQLException {
        val_CON.rollback(savepoint);
    }

    @Override
    public void releaseSavepoint(Savepoint savepoint) throws SQLException {
        val_CON.releaseSavepoint(savepoint);
    }

    @Override
    public Statement createStatement(int resultSetType, int resultSetConcurrency, int resultSetHoldability) throws SQLException {
        return val_CON.createStatement(resultSetType, resultSetConcurrency, resultSetHoldability);
    }

    @Override
    public PreparedStatement prepareStatement(String sql, int resultSetType, int resultSetConcurrency, int resultSetHoldability) throws SQLException {
        return val_CON.prepareStatement(sql, resultSetType, resultSetConcurrency, resultSetHoldability);
    }

    @Override
    public CallableStatement prepareCall(String sql, int resultSetType, int resultSetConcurrency, int resultSetHoldability) throws SQLException {
        return val_CON.prepareCall(sql, resultSetType, resultSetConcurrency, resultSetHoldability);
    }

    @Override
    public PreparedStatement prepareStatement(String sql, int autoGeneratedKeys) throws SQLException {
        return val_CON.prepareStatement(sql, autoGeneratedKeys);
    }

    @Override
    public PreparedStatement prepareStatement(String sql, int[] columnIndexes) throws SQLException {
        return val_CON.prepareStatement(sql, columnIndexes);
    }

    @Override
    public PreparedStatement prepareStatement(String sql, String[] columnNames) throws SQLException {
        return val_CON.prepareStatement(sql, columnNames);
    }

    @Override
    public Clob createClob() throws SQLException {
        return val_CON.createClob();
    }

    @Override
    public Blob createBlob() throws SQLException {
        return val_CON.createBlob();
    }

    @Override
    public NClob createNClob() throws SQLException {
        return val_CON.createNClob();
    }

    @Override
    public SQLXML createSQLXML() throws SQLException {
        return val_CON.createSQLXML();
    }

    @Override
    public boolean isValid(int timeout) throws SQLException {
        return val_CON.isValid(timeout);
    }

    @Override
    public void setClientInfo(String name, String value) throws SQLClientInfoException {
        val_CON.setClientInfo(name, value);
    }

    @Override
    public void setClientInfo(Properties properties) throws SQLClientInfoException {
        val_CON.setClientInfo(properties);
    }

    @Override
    public String getClientInfo(String name) throws SQLException {
        return val_CON.getClientInfo(name);
    }

    @Override
    public Properties getClientInfo() throws SQLException {
        return val_CON.getClientInfo();
    }

    @Override
    public Array createArrayOf(String typeName, Object[] elements) throws SQLException {
        return val_CON.createArrayOf(typeName, elements);
    }

    @Override
    public Struct createStruct(String typeName, Object[] attributes) throws SQLException {
        return val_CON.createStruct(typeName, attributes);
    }

    @Override
    public void setSchema(String schema) throws SQLException {
        val_CON.setSchema(schema);
    }

    @Override
    public String getSchema() throws SQLException {
        return val_CON.getSchema();
    }

    @Override
    public void abort(Executor executor) throws SQLException {
        val_CON.abort(executor);
    }

    @Override
    public void setNetworkTimeout(Executor executor, int milliseconds) throws SQLException {
        val_CON.setNetworkTimeout(executor, milliseconds);
    }

    @Override
    public int getNetworkTimeout() throws SQLException {
        return val_CON.getNetworkTimeout();
    }

    @Override
    public <T> T unwrap(Class<T> iface) throws SQLException {
        return val_CON.unwrap(iface);
    }

    @Override
    public boolean isWrapperFor(Class<?> iface) throws SQLException {
        return val_CON.isWrapperFor(iface);
    }
    
}
