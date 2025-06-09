/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.apro.db;

import com.apro.comercio.ListaProductos;
import com.apro.comercio.Producto;
import com.apro.comercio.Tienda;
import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author paula
 */
public class ConectorBD {
    
    /**
     * Map los pool de conexiones de distintos DataSources.
     */
    public static final Map<String, APDataSource> pool_BD = new HashMap<>();
    
    /**
     * Busca un DataSource especificado en el pool, si no esta lo crea.
     * 
     * @param usu_PARAM
     * @param pwd_PARAM
     * @param base_PARAM
     * @param driver_PARAM
     * @return 
     */
    
    //String nombre del archivo properties.
    public static synchronized APDataSource getDataSource(String file_PARAM){
        try {
            // usar el nombre del archivo properties.
            String key_MAP = file_PARAM;
            
            if(pool_BD.containsKey(key_MAP)){
                return pool_BD.get(key_MAP);
            }else{
                System.out.println("---- "+file_PARAM+" ----");
                
                APDataSource ds_MAP = new APDataSource();
                ds_MAP.setProperties(file_PARAM);
                ds_MAP.loadDriver();
                ds_MAP.createConnection();
                /*ds_MAP.setUsu_DS(usu_PARAM);
                ds_MAP.setPwd_DS(pwd_PARAM);
                ds_MAP.setDriver_DS(driver_PARAM);
                ds_MAP.loadDriver();
                ds_MAP.setUrl_DS(url_PARAM);
                ds_MAP.init();*/
                pool_BD.put(key_MAP, ds_MAP);
                
                return ds_MAP; 
            }
        } catch (SQLException sqle){
            System.err.println("Error en la conexión o consulta: " + sqle.getMessage());
            return null;
        } catch (IOException ioe){
            System.err.println("Error de archivo: " + ioe.getMessage());
            return null;
        }
    }
    
    /**
     * Trae tiendas de un producto en especifico.
     * 
     * @param idProd_PARAM
     * @param ds_PARAM
     * @return
     * @throws SQLException 
     */
    public static List<Tienda> getTiendaProd(
        int idProd_PARAM, APDataSource ds_PARAM) throws SQLException{
        
        //la lista
        List<Tienda> al_TND = new ArrayList<>();
        
        //conexion
        String qry_BD = "SELECT t.c_i_tienda,t.n_v_nom FROM negocio.c_tienda t "
        + "LEFT JOIN negocio.d_producto p on(t.c_i_tienda = p.c_i_tienda)"
        + "WHERE p.c_i_prod = " + idProd_PARAM + " AND p.d_v_edo = 1;";

        Connection con_POOL = ds_PARAM.getConnection();
        Statement stmt_CON = con_POOL.createStatement();
        ResultSet res_STMT = stmt_CON.executeQuery(qry_BD);
        
        boolean hayTiendas = false;
        while (res_STMT.next()) {
            hayTiendas = true;
            Tienda tnd_TMP = new Tienda();
            tnd_TMP.setId_TND(res_STMT.getInt(1));
            tnd_TMP.setNom_TND(res_STMT.getString(2));
            al_TND.add(tnd_TMP);
        }
        
        stmt_CON.close();
        res_STMT.close();
        
        if(!hayTiendas){
            return null;
        } else {
            return al_TND;
        }
    } 
    
    /**
     * Trae un producto segun su identificador.
     * @param idProd_PARAM
     * @param ds_PARAM
     * @return p_RES (objeto con producto).
     * @throws SQLException 
     */
    public static Producto getProducto(int idProd_PARAM, APDataSource ds_PARAM) throws SQLException{
        //producto
        Producto p_RES = new Producto();
        
        //conexion
        String qry_BD = "SELECT * FROM o_producto WHERE c_i_prod = " + idProd_PARAM + " AND d_v_edo = 1";
        Connection con_POOL = ds_PARAM.getConnection();
        Statement stmt_CON = con_POOL.createStatement();
        ResultSet res_STMT = stmt_CON.executeQuery(qry_BD);
        
        boolean existeProd = false;
        if (res_STMT.next()) {
            existeProd = true;
            String ID_PROD = res_STMT.getString("c_i_prod"); /// integer porque ahorra tiempo de procesamiento
            String nom_PROD = res_STMT.getString("n_v_nombre");
            String cant_PROD = res_STMT.getString("d_v_cant");
            String precio_PROD = res_STMT.getString("d_v_precio");
            String tipo_PROD = res_STMT.getString("d_v_tipo");
            String desc_PROD = res_STMT.getString("d_v_desc");
            String disp_PROD = res_STMT.getString("d_v_disp");
            String catego_PROD = res_STMT.getString("d_v_catego");

            int cant_NUM, disp_NUM, ID_NUM;
            float precio_NUM = Float.parseFloat(precio_PROD);
            
            try{
                ID_NUM = Integer.parseInt(ID_PROD);
                cant_NUM = Integer.parseInt(cant_PROD);
                disp_NUM = Integer.parseInt(disp_PROD);
            } catch (NumberFormatException nfe){
                ID_NUM = -1;
                cant_NUM = -1;    
                disp_NUM = -1;     
            }
            
            p_RES.setId(ID_NUM);
            p_RES.setNom(nom_PROD);
            p_RES.setCant(cant_NUM);
            p_RES.setPrecio(precio_NUM);
            p_RES.setTipo(tipo_PROD);
            p_RES.setDesc(desc_PROD);
            p_RES.setDisp(disp_NUM);
            p_RES.setCategoria(catego_PROD);
            
        }
        
        stmt_CON.close();
        res_STMT.close();
        
        if(!existeProd){
            return null;
        } else {
            return p_RES;
        }   
    }
    
    
    
    public static int delProdMast(
            int idProd_PARAM, APDataSource ds_PARAM) throws SQLException{
        //conexion
        String qry_BD = "UPDATE o_producto SET d_v_edo = 0 WHERE c_i_prod = " + idProd_PARAM;
        Connection con_POOL = ds_PARAM.getConnection();
        Statement stmt_CON = con_POOL.createStatement();
        int del_STMT = stmt_CON.executeUpdate(qry_BD);
        
        stmt_CON.close();
        
        if(del_STMT < 0){
            return -1;
        } else {
            return del_STMT;
        }
    }
    
    public static int delProdDet(int idProd_PARAM, APDataSource ds_PARAM) throws SQLException{
        //conexion
        String qry_BD = "UPDATE d_producto SET d_v_edo = 0 WHERE c_i_prod = " + idProd_PARAM;
        Connection con_POOL = ds_PARAM.getConnection();
        Statement stmt_CON = con_POOL.createStatement();
        int del_STMT = stmt_CON.executeUpdate(qry_BD);
        
        stmt_CON.close();
        
        if(del_STMT < 0){
            return -1;
        } else {
            return del_STMT;
        }
    }
    
    public static int insProdMast(
            int id_PARAM, Producto prod_PARAM, APDataSource ds_PARAM) throws SQLException{
        //conexion
        String qry_BD = "insert into o_producto"
        + "(c_i_usu,n_v_nombre,d_v_cant,d_v_precio,d_v_desc,d_v_tipo,d_v_disp,d_v_catego) "
        + "values ('" + id_PARAM + "','" + prod_PARAM.getNom() + "','"
        + prod_PARAM.getCant() + "','" + prod_PARAM.getPrecio() + "','"
        + prod_PARAM.getDesc() + "','" + prod_PARAM.getTipo() + "','"
        + prod_PARAM.getDisp() + "','" + prod_PARAM.getCategoria() + "');";
        Connection con_POOL = ds_PARAM.getConnection();
        Statement stmt_CON = con_POOL.createStatement();
        int in_STMT = stmt_CON.executeUpdate(qry_BD);
        
        stmt_CON.close();
        
        //si fue exitoso el registro se obtiene el id del mismo
        if(in_STMT > 0){
            qry_BD = "SELECT LAST_INSERT_ID();";
            con_POOL = ds_PARAM.getConnection();
            stmt_CON = con_POOL.createStatement();
            ResultSet id_STMT = stmt_CON.executeQuery(qry_BD);
            
            int id_PROD =-1;
            
            boolean hayID = false;
            if (id_STMT.next()) {
                hayID = true;
                id_PROD = id_STMT.getInt(1);
            }

            stmt_CON.close();
            id_STMT.close();

            if(!hayID){
                return -1;
            } else {
                return id_PROD;
            }
        } else {
            return -1;
        }
    }
    
    /**
     * Trae el id de tienda de las tiendas
     * de un producto en especifico.
     * 
     * @param idProd_PARAM
     * @param ds_PARAM
     * @return 
     * @throws SQLException 
     */
    public static ArrayList<Integer> getTiendaIDProd(
            int idProd_PARAM, APDataSource ds_PARAM) throws SQLException{
        
        //la lista
        ArrayList<Integer> al_TND = new ArrayList<>();
        
        //conexion
        String qry_BD = "SELECT c_i_tienda FROM d_producto "
        + "WHERE c_i_prod = " + idProd_PARAM;
        Connection con_POOL = ds_PARAM.getConnection();
        Statement stmt_CON = con_POOL.createStatement();
        ResultSet res_STMT = stmt_CON.executeQuery(qry_BD);
        
        boolean hayTiendas = false;
        while (res_STMT.next()) {
            hayTiendas = true;
            al_TND.add(res_STMT.getInt(1));
        }
        
        stmt_CON.close();
        res_STMT.close();
        
        if(!hayTiendas){
            return null;
        } else {
            return al_TND;
        }
    }
    
    /**
     * Trae el id de tienda de las tiendas
     * de un producto en especifico.
     * 
     * @param idProd_PARAM
     * @param ds_PARAM
     * @return 
     * @throws SQLException 
     */
    public static ArrayList<Integer> getTiendaIDProdON(
            int idProd_PARAM, APDataSource ds_PARAM) throws SQLException{
        
        //la lista
        ArrayList<Integer> al_TND = new ArrayList<>();
        
        //conexion
        String qry_BD = "SELECT c_i_tienda FROM d_producto "
        + "WHERE c_i_prod = " + idProd_PARAM + " AND d_v_edo = 1;";
        Connection con_POOL = ds_PARAM.getConnection();
        Statement stmt_CON = con_POOL.createStatement();
        ResultSet res_STMT = stmt_CON.executeQuery(qry_BD);
        
        boolean hayTiendas = false;
        while (res_STMT.next()) {
            hayTiendas = true;
            al_TND.add(res_STMT.getInt(1));
        }
        
        stmt_CON.close();
        res_STMT.close();
        
        if(!hayTiendas){
            return null;
        } else {
            return al_TND;
        }
    }
    
    public static int delDetDet(
            int idProd_PARAM, int idTnd_PARAM, APDataSource ds_PARAM) throws SQLException {
        //conexion
        String qry_BD = "UPDATE d_producto SET d_v_edo = 0 WHERE c_i_prod = " + idProd_PARAM
        + " AND c_i_tienda = " + idTnd_PARAM;
        Connection con_POOL = ds_PARAM.getConnection();
        Statement stmt_CON = con_POOL.createStatement();
        int del_STMT = stmt_CON.executeUpdate(qry_BD);
        
        stmt_CON.close();
        
        if(del_STMT < 0){
            return -1;
        } else {
            return del_STMT;
        }
    }
    
    public static int setDetalle(
            int idProd_PARAM, int idTnd_PARAM, APDataSource ds_PARAM) throws SQLException{
        //conexion
        String qry_BD = "insert into d_producto (c_i_prod,c_i_tienda) "
        + "values ('" + idProd_PARAM + "','" + idTnd_PARAM + "');";
        Connection con_POOL = ds_PARAM.getConnection();
        Statement stmt_CON = con_POOL.createStatement();
        int det_STMT = stmt_CON.executeUpdate(qry_BD);
        
        stmt_CON.close();
        
        if(det_STMT < 0){
            return -1;
        } else {
            return det_STMT;
        }
    }
    
    public static int setDetDet(
            int idProd_PARAM, int idTnd_PARAM, APDataSource ds_PARAM) throws SQLException {
        //conexion
        String qry_BD = "UPDATE d_producto SET d_v_edo = 1 WHERE c_i_prod = " + idProd_PARAM
        + " AND c_i_tienda = " + idTnd_PARAM;
        Connection con_POOL = ds_PARAM.getConnection();
        Statement stmt_CON = con_POOL.createStatement();
        int set_STMT = stmt_CON.executeUpdate(qry_BD);
        
        stmt_CON.close();
        
        if(set_STMT < 0){
            return -1;
        } else {
            return set_STMT;
        }
    }
}
