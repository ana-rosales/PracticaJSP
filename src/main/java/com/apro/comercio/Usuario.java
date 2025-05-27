/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.apro.comercio;

/**
 *
 * @author paula
 */
public class Usuario {
    
    private String nom_USU, contra_USU;
    private int id_USU;
    private boolean logged;

    public Usuario() {
    }

    public int getId_USU() {
        return id_USU;
    }

    public void setId_USU(int id_USU) {
        this.id_USU = id_USU;
    }

    public String getNom_USU() {
        return nom_USU;
    }

    public void setNom_USU(String nom_USU) {
        this.nom_USU = nom_USU;
    }

    public String getContra_USU() {
        return contra_USU;
    }

    public void setContra_USU(String contra_USU) {
        this.contra_USU = contra_USU;
    }

    public boolean isLogged() {
        return logged;
    }

    public void setLogged(boolean logged) {
        this.logged = logged;
    }
    
}
