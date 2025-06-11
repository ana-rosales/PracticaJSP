<%@page import="com.apro.comercio.ListaProductos"%>
<%@page contentType="text/html" pageEncoding="UTF-8" import="
        com.apro.comercio.Producto,com.apro.db.ConectorBD,java.sql.SQLException,
        java.sql.ResultSet,java.sql.Connection,java.util.Arrays,
        com.apro.db.APDataSource,java.sql.Statement,com.apro.comercio.Usuario,
        java.util.ArrayList,java.util.List,com.apro.comercio.Tienda"%>
<%!
    public int updProdMast(
            Producto prod_PARAM, APDataSource ds_PARAM) throws SQLException{
        //conexion
        String qry_BD = "UPDATE o_producto "
        + "SET n_v_nombre = '" + prod_PARAM.getNom() + "', d_v_cant = " + prod_PARAM.getCant()
        + ", d_v_precio = " + prod_PARAM.getPrecio() + ", d_v_desc = '" + prod_PARAM.getDesc()
        + "', d_v_tipo = '" + prod_PARAM.getTipo() + "', d_v_disp = " + prod_PARAM.getDisp()
        + ", d_v_catego = '" + prod_PARAM.getCategoria() + "' "
        + "WHERE c_i_prod = " + prod_PARAM.getId();
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
%>
<%
    //Obtener el DataSource para consultar.  
    APDataSource ds_CON = ConectorBD.getDataSource("negocio.properties");
    
    // SESSION
    Object usu_OBJ = session.getAttribute("usu_SESS");
    Object lp_OBJ = session.getAttribute("lp_SESS");
    Object prod_OBJ = session.getAttribute("prod_MODIF");
    
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
        
        //arreglo de tiendas
        //Convertir arreglo string de javascript a arreglo int java
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
                Producto prod_NEW = new Producto();
                prod_NEW.setNom(prod);
                prod_NEW.setDesc(desc);
                prod_NEW.setTipo(tipo);
                prod_NEW.setCategoria(categoria);
                prod_NEW.setPrecio(tmp_jvf_precio);
                prod_NEW.setCant(tmp_jvi_cant);
                prod_NEW.setDisp(disp_INT);
                
                //si existe un producto, actualizar el producto correspondiente
                if(prod_OBJ != null){
                    Producto prod_MODIF = (Producto) prod_OBJ;
                    prod_NEW.setId(prod_MODIF.getId());
                        
                    try{
                        // actualizar maestro en la bd.
                        int resUpdMtr = updProdMast(prod_NEW, ds_CON);
                        if(resUpdMtr > 0){
                            System.out.println("exito al actualizar.");
                        }
                        // actualizar detalles en la bd y en lista.
                        List<Tienda> lt_PROD = prod_MODIF.getTiendas();
                        if(lt_PROD != null){
                            //recorrerlos
                            for(Tienda tnd_PROD: lt_PROD){
                                //si c_i_tienda NO esta en tnd_ARR d_v_edo BORRADO LOGICO DE DETALLE
                                if(!tnd_ARR.contains(tnd_PROD.getId_TND())){
                                    int detDetDet = ConectorBD.delDetDet(
                                        prod_MODIF.getId(), tnd_PROD.id_TND, ds_CON);
                                    if(detDetDet > 0){
                                        System.out.println("exito al eliminar.");
                                    }
                                // si c_i_tienda ESTA en tnd_ARR RESTAURAR ESTADO DE BORRADO LOGICO
                                } else {
                                    int IX_TND = tnd_ARR.indexOf(tnd_PROD.getId_TND());
                                    tnd_ARR.remove(IX_TND);
                                    int setDetDet = ConectorBD.setDetDet(
                                        prod_MODIF.getId(), tnd_PROD.getId_TND(), ds_CON);
                                    //en la lista solo se mantiene
                                    if(setDetDet > 0){
                                        System.out.println("exito al eliminar.");
                                    }
                                }
                            }
                        }
                        //crear el detalle para las c_i_tienda restantes en tnd_ARR
                        if(!tnd_ARR.isEmpty()){
                            for(Integer tnd_ID: tnd_ARR){
                                int set_DET = ConectorBD.setDetalle(
                                    prod_MODIF.getId(), tnd_ID, ds_CON);
                                if(set_DET > 0){
                                    System.out.println("exito registro");
                                }
                            }
                        }
                        //actualizar detalles en lista
                        prod_NEW.setTiendas(ConectorBD.getTiendaProd(prod_MODIF.getId(), ds_CON));
                        
                        //si no hay lista crear una nueva
                        ListaProductos lp_SESS;
                        if(lp_OBJ != null){
                            lp_SESS = (ListaProductos) lp_OBJ;
                            int IX_MODIF = lp_SESS.indexOf(prod_MODIF);
                            lp_SESS.set(prod_NEW, IX_MODIF);
                        } else {
                            lp_SESS = new ListaProductos(prod_NEW);
                        }
                        session.setAttribute("lp_SESS", lp_SESS);
                    } catch (SQLException e) {
                        System.err.println("Error en la conexión o consulta: " + e.getMessage());
                    }

                } else {
                    // Agregarlo a la BASE si no existe
                    try{
                        prod_NEW.setId(ConectorBD.insProdMast(
                            usu_USU.getId_USU(), prod_NEW, ds_CON)); //se obtiene el id del nuevo producto
                        
                        if(prod_NEW.getId() >= 0){
                            System.out.println("exito registro");
                        }
                        
                        //crear el detalle para las c_i_tienda en tnd_ARR
                        if(!tnd_ARR.isEmpty()){
                            for(Integer tnd_ID: tnd_ARR){
                                int set_DET = ConectorBD.setDetalle(
                                prod_NEW.getId(), tnd_ID, ds_CON);
                                if(set_DET > 0){
                                    System.out.println("exito registro");
                                }
                            }
                        }
                        //guardar detalles en lista
                        prod_NEW.setTiendas(ConectorBD.getTiendaProd(
                            prod_NEW.getId(), ds_CON));
                        
                        //si no hay lista crear una nueva
                        ListaProductos lp_SESS;
                        if(lp_OBJ != null){
                            lp_SESS = (ListaProductos) lp_OBJ;
                            lp_SESS.add(prod_NEW);
                        } else {
                            lp_SESS = new ListaProductos(prod_NEW);
                        }
                        session.setAttribute("lp_SESS", lp_SESS);
                   
                    } catch (SQLException e) {
                        System.err.println("Error en la conexión o consulta: " + e.getMessage());
                    }
                }
                //se elimina el atributo con el id, ya no es necesario.
                session.removeAttribute("prod_MODIF");
            } else {
                valModif = 2;
            }
        }
%>
<input type="hidden" id="resModif" value=<%= valModif %>>
<%
    }
%>