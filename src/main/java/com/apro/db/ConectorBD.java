/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.apro.db;

import com.apro.comercio.ListaProductos;
import com.apro.comercio.Producto;
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

}
