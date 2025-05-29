<%@page import="java.util.ArrayList"%>
<%@page import="com.apro.comercio.Usuario"%>
<%@page import="java.sql.Statement"%>
<%@page import="com.apro.db.APConnection"%>
<%@page import="com.apro.db.APDataSource"%>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@page import="
        com.apro.comercio.Producto,com.apro.db.ConectorBD,java.sql.SQLException,
        java.sql.ResultSet,java.sql.Connection,java.util.Arrays"%>
<%
    //Obtener el DataSource para consultar.
    String usu_BD = "root", 
            pwd_BD = "admin", 
            base_BD = "negocio", 
            driver_BD = "org.mariadb.jdbc.Driver",
            url_BD = "jdbc:mariadb://localhost:3360/";    
    APDataSource ds_CON = ConectorBD.getDataSource(usu_BD, pwd_BD, base_BD, driver_BD, url_BD);
    
    // SESSION
    Object usu_OBJ = session.getAttribute("usu_SESS");
    Object prod_MODIF = session.getAttribute("idProd_MODIF");
    
    //resultado modif
    int valModif;
    
    //no se ejecuta nada si no hay una sesion iniciada
    if(usu_OBJ != null){
        Usuario usu_USU = (Usuario) usu_OBJ;
    
        //obtener campos encapsulados en el post
        String prod = request.getParameter("prod"),
        cant = request.getParameter("cant"),
        precio = request.getParameter("precio"),
        desc = request.getParameter("desc"),
        tipo = request.getParameter("tipo"),
        disp = request.getParameter("disp"),
        categoria = request.getParameter("categoria"),
        tienda = request.getParameter("tienda");
        
        //Convertir arreglo string de javascript a arreglo java
        tienda = tienda.replaceAll("\"", "");
        tienda = tienda.replace("[", "");
        tienda = tienda.replace("]", "");
        String[] jsElements = tienda.split(","); // Separar los elementos por comas
        ArrayList<Integer> tnd_ARR = new ArrayList<>(); //arraylist de tiendas seleccionadas

        //si hay tiendas seleccionadas, se convierte a numero.
        if(jsElements.length > 0 && !jsElements[0].equals("")){
            for (int i = 0; i < jsElements.length; i++) {
                tnd_ARR.add(Integer.parseInt(jsElements[i].trim())); // Convertir a Integer y eliminar espacios
            }
        }
        
        //Disponibilidad.
        int disp_INT;
        if(disp.equals("0")){
            disp_INT = 0;
        } else {
            disp_INT = 1;
        }

        //validar campos vacios
        if(prod.equals("") || cant.equals("") || precio.equals("") || desc.equals("") || tipo == null || categoria.equals("")){
            valModif = 1;
        } else {
            //validar campos numericos
            float tmp_jvf_precio = Float.parseFloat(precio);
            int tmp_jvi_cant;

            try{
                tmp_jvi_cant = Integer.parseInt(cant);
            } catch (NumberFormatException nfe){
                tmp_jvi_cant = -1;     
            }
                
            //aquí el producto ES VÁLIDO
            if(tmp_jvi_cant >= 0 && tmp_jvf_precio >= 0){
                valModif = 0;
                //crear objeto Producto.
                Producto amc_jvo_prod = new Producto();
                amc_jvo_prod.setNom(prod);
                amc_jvo_prod.setDesc(desc);
                amc_jvo_prod.setTipo(tipo);
                amc_jvo_prod.setCategoria(categoria);
                amc_jvo_prod.setPrecio(tmp_jvf_precio);
                amc_jvo_prod.setCant(tmp_jvi_cant);
                amc_jvo_prod.setDisp(disp_INT);
                
                //si existe un c_i_prod, actualizar el producto correspondiente
                if(prod_MODIF != null){
                    Integer prodInt_MODIF = (Integer) prod_MODIF;
                    amc_jvo_prod.setId(prodInt_MODIF);
                        
                    try{
                        // actualizar maestro
                        int resUpdMtr = ConectorBD.updProdMast(amc_jvo_prod, ds_CON);
                        if(resUpdMtr > 0){
                            System.out.println("exito al actualizar.");
                        }
                        
                        // actualizar detalles
                        try{
                            //obtener todos los detalles existentes del producto.
                            ArrayList<Integer> tnd_PROD = ConectorBD.getTiendaIDProd(prodInt_MODIF, ds_CON);
                            if(tnd_PROD != null){
                                //recorrerlos
                                for(Integer tnd_ID: tnd_PROD){
                                    //si c_i_tienda NO esta en tnd_ARR d_v_edo BORRADO LOGICO DE DETALLE
                                    if(!tnd_ARR.contains(tnd_ID)){
                                        int detDetDet = ConectorBD.delDetDet(prodInt_MODIF, tnd_ID, ds_CON);
                                        if(detDetDet > 0){
                                            System.out.println("exito al eliminar.");
                                        }
                                    // si c_i_tienda ESTA en tnd_ARR RESTAURAR ESTADO DE BORRADO LOGICO
                                    } else {
                                        tnd_ARR.remove(tnd_ID);
                                        int setDetDet = ConectorBD.setDetDet(prodInt_MODIF, tnd_ID, ds_CON);
                                        if(setDetDet > 0){
                                            System.out.println("exito al eliminar.");
                                        }
                                    }
                                }
                            }
                            //crear el detalle para las c_i_tienda restantes en tnd_ARR
                            if(!tnd_ARR.isEmpty()){
                                for(Integer tnd_ID: tnd_ARR){
                                    int set_DET = ConectorBD.setDetalle(prodInt_MODIF, tnd_ID, ds_CON);
                                    if(set_DET > 0){
                                        System.out.println("exito registro");
                                    }
                                }
                            }
                        } catch (SQLException e) {
                            System.err.println("Error en la conexión o consulta: " + e.getMessage());
                        }
                        
                        //se elimina el atributo con el id, ya no es necesario.
                        session.removeAttribute("idProd_MODIF");
                    } catch (SQLException e) {
                        System.err.println("Error en la conexión o consulta: " + e.getMessage());
                    }

                } else {
                    // Agregarlo a la BASE si no existe
                    try{
                        int idProd = ConectorBD.insProdMast(
                        usu_USU.getId_USU(), amc_jvo_prod, ds_CON);
                        
                        if(idProd >= 0){
                            System.out.println("exito registro");
                        }
                        
                        //crear el detalle para las c_i_tienda en tnd_ARR
                        if(!tnd_ARR.isEmpty()){
                            for(Integer tnd_ID: tnd_ARR){
                                int set_DET = ConectorBD.setDetalle(idProd, tnd_ID, ds_CON);
                                if(set_DET > 0){
                                    System.out.println("exito registro");
                                }
                            }
                        }
                    } catch (SQLException e) {
                        System.err.println("Error en la conexión o consulta: " + e.getMessage());
                    }
                    
                    
                }
            } else {
                valModif = 2;
            }
        }
%>
<input type="hidden" id="resModif" value=<%= valModif %>>
<%
    }
%>