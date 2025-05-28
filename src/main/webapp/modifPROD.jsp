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
        int[] tnd_ARR = new int[jsElements.length]; // Crear un arreglo de Java

        //si hay tiendas seleccionadas, se convierte a numero.
        if(jsElements.length > 0 && !jsElements[0].equals("")){
            for (int i = 0; i < jsElements.length; i++) {
                tnd_ARR[i] = Integer.parseInt(jsElements[i].trim()); // Convertir a Integer y eliminar espacios
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
                        int resUpdMtr = ConectorBD.updProdMast(amc_jvo_prod, ds_CON);
                        if(resUpdMtr > 0){
                            System.out.println("exito al actualizar.");
                        }
                        //se elimina el atributo con el id, ya no es necesario.
                        session.removeAttribute("idProd_MODIF");
                        
                        //si hay tiendas, insertar los detalles para este producto.
                        /*if(jsElements.length > 0 && !jsElements[0].equals("")){
                            for(int i = 0; i < tnd_ARR.length ; i++){
                                try{
                                    
                                } catch (SQLException e) {
                                    System.err.println("Error en la conexión o consulta: " + e.getMessage());
                                }
                            }
                        }*/
                    } catch (SQLException e) {
                        System.err.println("Error en la conexión o consulta: " + e.getMessage());
                    }

                } else {
                    // Agregarlo a la BASE si no existe
                    try{
                        int insProd = ConectorBD.insProdMast(
                        usu_USU.getId_USU(), amc_jvo_prod, ds_CON);
                        if(insProd > 0){
                            System.out.println("exito registro");
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