/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.apro.comercio;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;

/**
 * En este objeto se almacenan todos los productos de un vendedor.
 * 
 * Se puede crear con una lista, o pasandole los elementos de la lista.
 * 
 * @author paula
 */
public class ListaProductos {
    
    private ArrayList<Producto> list_PROD;
    
    /**
     * CONSTRUCTORES
     */
    
    /**
     * Constructor vacío crea una ArrayList vacia.
     */
    public ListaProductos() {
        this.list_PROD = new ArrayList<>();
    }
    /**
     * A partir de una lista existente.
     * @param prod 
     */
    public ListaProductos(ArrayList<Producto> alProd_PARAM) {
        this.list_PROD = alProd_PARAM;
    }
    /**
     * A partir de un arreglo de elementos.
     * @param productos 
     */
    public ListaProductos(Producto[] arrProd_PARAM){
        this.list_PROD = new ArrayList<>(Arrays.asList(arrProd_PARAM));
    }
    
    /**
     * A partir de un elemento inicial.
     * @param prod_PARAM
     */
    public ListaProductos(Producto prod_PARAM){
        this.list_PROD = new ArrayList<>();
        this.list_PROD.add(prod_PARAM);
    }

    /**
     * GETTERS & SETTERS.
     */
    
    public ArrayList<Producto> getProds() {
        return list_PROD;
    }

    public void setProds(ArrayList<Producto> tmp_jvl_prods) {
        this.list_PROD = tmp_jvl_prods;
    }
    
    /**
     * METODOS DE CLASE. 
     */
    
    /**
     * Método para saber si está vacía la lista.
     * @return booleano
     */
    public boolean esVacia(){
        return this.list_PROD.isEmpty();
    }
    
    /**
     * Pone un producto en el lugar de otro
     * y devuelve el otro.
     * 
     * @param prod_PARAM
     * @param IX_PARAM
     * @return 
     */
    public Producto set(Producto prod_PARAM, int IX_PARAM){
        return this.list_PROD.set(IX_PARAM, prod_PARAM);
    }
    
    /**
     * Devuelve el posicion del producto en la lista.
     * 
     * @param prod_PARAM
     * @return 
     */
    public int indexOf(Producto prod_PARAM){
        return this.list_PROD.indexOf(prod_PARAM);
    }
    
    /**
     * Devuelve el producto segun su indice y lo elimina de la lista.
     * 
     * @param idx_jvi_prod
     * @return 
     */
    public Producto remove(int idx_jvi_prod){
        return this.list_PROD.remove(idx_jvi_prod);
    }
    
    /**
     * Devuelve y quita el producto indicado
     * de la lista.
     * @param IDBD_PARAM
     * @return 
     */
    public Producto remove(Producto IDBD_PARAM){
        int IX_PROD = this.list_PROD.indexOf(IDBD_PARAM);
        return this.list_PROD.remove(IX_PROD);
    }
    
    /**
     * Devuelve el producto con el ID de BD indicado
     * de la lista.
     * @param IDBD_PARAM
     * @return 
     */
    public Producto get(int IDBD_PARAM){
        for(Producto res: this.list_PROD){
            if(res.getId() == IDBD_PARAM){
                return res;
            }
        }
        return null;
    }
    
    public Producto getIX(int IX_PARAM){
        return this.list_PROD.get(IX_PARAM);
    }
    
    /**
     * Elimina el producto con el ID de BD especificado.
     * @param IDBD_PARAM
     * @return 
     */
    public boolean deleteWithID(int IDBD_PARAM){
        return this.list_PROD.removeIf(prod_TMP -> prod_TMP.getId() == IDBD_PARAM);
    }
    
    public int size(){
        return this.list_PROD.size();
    }
    public void add(Producto prod_PARAM){
        this.list_PROD.add(prod_PARAM);
    }
    
    public void sort(){
        Collections.sort(this.list_PROD, new Comparator<Producto>() {
            public int compare(Producto p1, Producto p2) {
                return Integer.compare(p1.getId(), p2.getId());
            }
        });
    }
    
    public void sortReverse(){
        Collections.sort(this.list_PROD, new Comparator<Producto>() {
            public int compare(Producto p1, Producto p2) {
                return Integer.compare(p2.getId(),p1.getId());
            }
        });
    }
}
