/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.apro.db;

import com.apro.comercio.ListaProductos;
import com.apro.comercio.Producto;
import com.apro.comercio.Tienda;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
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
    public static synchronized APDataSource getDataSource(
            String usu_PARAM, String pwd_PARAM, String base_PARAM, String driver_PARAM, String url_PARAM){
        try {
            String key_MAP = usu_PARAM + " " + pwd_PARAM + " " + base_PARAM + " " + driver_PARAM;
            
            if(pool_BD.containsKey(key_MAP)){
                return pool_BD.get(key_MAP);
            }else{
                APDataSource ds_MAP = new APDataSource();
                ds_MAP.setUsu_DS(usu_PARAM);
                ds_MAP.setPwd_DS(pwd_PARAM);
                ds_MAP.setBase_DS(base_PARAM);
                ds_MAP.setDriver_DS(driver_PARAM);
                ds_MAP.loadDriver();
                ds_MAP.setUrl_DS(url_PARAM + base_PARAM);
                ds_MAP.init();
                pool_BD.put(key_MAP, ds_MAP);
                
                return ds_MAP; 
            }
        } catch (SQLException e){
            System.err.println("Error en la conexión o consulta: " + e.getMessage());
            return null;
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
        APConnection con_POOL = ds_PARAM.getConnection();
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
        
        con_POOL.close();
        stmt_CON.close();
        res_STMT.close();
        
        if(!existeProd){
            return null;
        } else {
            return p_RES;
        }   
    }
    
    /**
     * Trae los productos de un usuario.
     * 
     * @param id_PARAM
     * @param ds_PARAM
     * @return
     * @throws SQLException 
     */
    public static ListaProductos getProdUsu(int id_PARAM, APDataSource ds_PARAM) throws SQLException{
        
        //lista
        ListaProductos lp_RES = new ListaProductos();
        
        //conexion
        String qry_BD = "SELECT * FROM o_producto WHERE c_i_usu = " + id_PARAM + " AND d_v_edo = 1";
        APConnection con_POOL = ds_PARAM.getConnection();
        Statement stmt_CON = con_POOL.createStatement();
        ResultSet res_STMT = stmt_CON.executeQuery(qry_BD);
        
        boolean tieneProd_USU = false;
        while (res_STMT.next()) {
            Producto prod_TMP = new Producto();
            tieneProd_USU = true;
            
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
            
            prod_TMP.setId(ID_NUM);
            prod_TMP.setNom(nom_PROD);
            prod_TMP.setCant(cant_NUM);
            prod_TMP.setPrecio(precio_NUM);
            prod_TMP.setTipo(tipo_PROD);
            prod_TMP.setDesc(desc_PROD);
            prod_TMP.setDisp(disp_NUM);
            prod_TMP.setCategoria(catego_PROD);
            
            lp_RES.add(prod_TMP);
        }
        
        con_POOL.close();
        stmt_CON.close();
        res_STMT.close();
        
        if(!tieneProd_USU){
            return null;
        } else {
            return lp_RES;
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
    public static ArrayList<String> getTiendaProd(int idProd_PARAM, APDataSource ds_PARAM) throws SQLException{
        
        //la lista
        ArrayList<String> al_TND = new ArrayList<>();
        
        //conexion
        String qry_BD = "SELECT t.n_v_nom FROM negocio.c_tienda t LEFT JOIN negocio.d_producto p "
                    + "on(t.c_i_tienda = p.c_i_tienda) WHERE p.c_i_prod = " + idProd_PARAM;
        APConnection con_POOL = ds_PARAM.getConnection();
        Statement stmt_CON = con_POOL.createStatement();
        ResultSet res_STMT = stmt_CON.executeQuery(qry_BD);
        
        boolean hayTiendas = false;
        while (res_STMT.next()) {
            hayTiendas = true;
            al_TND.add(res_STMT.getString(1));
        }
        
        con_POOL.close();
        stmt_CON.close();
        res_STMT.close();
        
        if(!hayTiendas){
            return null;
        } else {
            return al_TND;
        }
    }
    
    /**
     * Trae todas las tiendas registradas en BD.
     * @param ds_PARAM
     * @return
     * @throws SQLException 
     */
    public static ArrayList<Tienda> getTiendas(APDataSource ds_PARAM) throws SQLException{
        //la lista
        ArrayList<Tienda> al_TND = new ArrayList<>();
        
        //conexion
        String qry_BD = "SELECT c_i_tienda,n_v_nom FROM c_tienda";
        APConnection con_POOL = ds_PARAM.getConnection();
        Statement stmt_CON = con_POOL.createStatement();
        ResultSet res_STMT = stmt_CON.executeQuery(qry_BD);
        
        boolean hayTiendas = false;
        while (res_STMT.next()) {
            hayTiendas = true;
            Tienda tnd_BD = new Tienda();
            tnd_BD.setId_TND(Integer.parseInt(res_STMT.getString("c_i_tienda")));
            tnd_BD.setNom_TND(res_STMT.getString("n_v_nom"));
            
            al_TND.add(tnd_BD);
        }
        
        con_POOL.close();
        stmt_CON.close();
        res_STMT.close();
        
        if(!hayTiendas){
            return null;
        } else {
            return al_TND;
        }
    }
    
    public static int delProdMast(int idProd_PARAM, APDataSource ds_PARAM) throws SQLException{
        //conexion
        String qry_BD = "UPDATE o_producto SET d_v_edo = 0 WHERE c_i_prod = " + idProd_PARAM;
        APConnection con_POOL = ds_PARAM.getConnection();
        Statement stmt_CON = con_POOL.createStatement();
        int del_STMT = stmt_CON.executeUpdate(qry_BD);
        
        con_POOL.close();
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
        APConnection con_POOL = ds_PARAM.getConnection();
        Statement stmt_CON = con_POOL.createStatement();
        int del_STMT = stmt_CON.executeUpdate(qry_BD);
        
        con_POOL.close();
        stmt_CON.close();
        
        if(del_STMT < 0){
            return -1;
        } else {
            return del_STMT;
        }
    }
    
    public static int updProdMast(
            Producto prod_PARAM, APDataSource ds_PARAM) throws SQLException{
        //conexion
        String qry_BD = "UPDATE o_producto "
        + "SET n_v_nombre = '" + prod_PARAM.getNom() + "', d_v_cant = " + prod_PARAM.getCant()
        + ", d_v_precio = " + prod_PARAM.getPrecio() + ", d_v_desc = '" + prod_PARAM.getDesc()
        + "', d_v_tipo = '" + prod_PARAM.getTipo() + "', d_v_disp = " + prod_PARAM.getDisp()
        + ", d_v_catego = '" + prod_PARAM.getCategoria() + "' "
        + "WHERE c_i_prod = " + prod_PARAM.getId();
        APConnection con_POOL = ds_PARAM.getConnection();
        Statement stmt_CON = con_POOL.createStatement();
        int del_STMT = stmt_CON.executeUpdate(qry_BD);
        
        con_POOL.close();
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
        APConnection con_POOL = ds_PARAM.getConnection();
        Statement stmt_CON = con_POOL.createStatement();
        int del_STMT = stmt_CON.executeUpdate(qry_BD);
        
        con_POOL.close();
        stmt_CON.close();
        
        if(del_STMT < 0){
            return -1;
        } else {
            return del_STMT;
        }
    }
    
    
}
