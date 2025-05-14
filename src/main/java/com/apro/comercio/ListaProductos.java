/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.apro.comercio;

import java.util.ArrayList;
import java.util.Arrays;
import java.io.Serializable;

/**
 * En este objeto se almacenan todos los productos de un vendedor.
 * 
 * Se puede crear con una lista, o pasandole los elementos de la lista.
 * 
 * @author paula
 */
public class ListaProductos {
    
    private ArrayList<Producto> amc_jal_prods;
    
    /**
     * CONSTRUCTORES
     */
    
    //Constructor vacío crea una ArrayList nueva.
    public ListaProductos() {
        this.amc_jal_prods = new ArrayList<>();
    }
    
    //A partir de una lista existente.
    public ListaProductos(ArrayList<Producto> prod) {
        this.amc_jal_prods = prod;
    }
    
    //A partir de un arreglo de elementos.
    public ListaProductos(Producto[] productos){
        this.amc_jal_prods = new ArrayList<>(Arrays.asList(productos));
    }

    /**
     * GETTERS & SETTERS.
     */
    
    public ArrayList<Producto> getProds() {
        return amc_jal_prods;
    }

    public void setProds(ArrayList<Producto> tmp_jvl_prods) {
        this.amc_jal_prods = tmp_jvl_prods;
    }
    
    /**
     * METODOS DE CLASE. 
     */
    
    /**
     * Método para saber si está vacía la lista.
     * @return booleano
     */
    public boolean cfg_jmb_vacia(){
        return this.amc_jal_prods.isEmpty();
    }
    
    public void cfg_jmv_add(Producto elm_jvo_prod){
        this.amc_jal_prods.add(elm_jvo_prod);
    }
    
    public int cfg_jmi_indexOf(Producto elm_jvo_prod){
        return this.amc_jal_prods.indexOf(elm_jvo_prod);
    }
    
    public Producto cfg_jmo_remove(int idx_jvi_prod){
        return this.amc_jal_prods.remove(idx_jvi_prod);
    }
    
}
