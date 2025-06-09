<%@page contentType="text/html" pageEncoding="UTF-8" import="
        java.sql.SQLException,java.sql.ResultSet,java.sql.Connection,
        com.apro.db.APDataSource,java.util.ArrayList,com.apro.comercio.Tienda,
        com.apro.db.ConectorBD,java.sql.Statement,java.util.List,
        com.apro.comercio.ListaProductos,com.apro.comercio.Producto" %>
<%!
    /**
     * Trae todas las tiendas registradas en BD.
     * @param ds_PARAM
     * @return
     * @throws SQLException 
     */
    public ArrayList<Tienda> getTiendas(APDataSource ds_PARAM) throws SQLException{
        //la lista
        ArrayList<Tienda> al_TND = new ArrayList<>();
        
        //conexion
        String qry_BD = "SELECT c_i_tienda,n_v_nom FROM c_tienda";
        Connection con_POOL = ds_PARAM.getConnection();
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
        
        stmt_CON.close();
        res_STMT.close();
        
        if(!hayTiendas){
            return null;
        } else {
            return al_TND;
        }
    }
%>
<%
    //Obtener el DataSource para consultar.
    APDataSource ds_CON = ConectorBD.getDataSource("negocio.properties");
    
    //Obtener los datos encapsulados en el POST.
    String idProd_REQ = request.getParameter("idProd");
    
    // SESSION
    Object usu_OBJ = session.getAttribute("usu_SESS");
    Object lp_OBJ = session.getAttribute("lp_SESS");
   
    //si no hay sesion no se muestra form
    if(usu_OBJ != null){
%>
    <div class="uk-modal-dialog uk-margin-auto-vertical uk-background-secondary uk-light">
        <div class="uk-modal-header uk-background-secondary uk-light">
            <h2 id="crearProducto_TIT" class="uk-modal-title">Ingresar producto.</h2>
        </div>
        <div class="uk-modal-body">
            <fieldset class="uk-fieldset uk-column-1-3@m">
                <div class="uk-margin">
                    <input class="uk-input" type="text" id="prod" name="prod" placeholder="Nombre del producto" aria-label="Input">
                </div>
                <div class="uk-margin">
                    <input class="uk-input" type="number" id="cant" name="cant" placeholder="Cantidad" aria-label="Input">
                </div>
                <div class="uk-margin">
                    <input class="uk-input" type="number" id="precio" name="precio" placeholder="Precio" aria-label="Input" max="99999.99">
                </div>
                <div class="uk-margin">
                    <textarea class="uk-textarea" rows="10" cols="100" name="desc" id="desc" rows="10" placeholder="Descripción del producto" aria-label="Textarea"></textarea>
                </div>
                <div class="uk-margin uk-grid-small uk-child-width-auto uk-grid">
                    <label><input class="uk-radio" type="radio" name="tipo" id="permanente" value="Permanente"> Producto permanente</label>
                    <label><input class="uk-radio" type="radio" name="tipo" id="especial" value="Especial"> Edición especial</label>
                </div>
                <div class="uk-margin uk-grid-small uk-child-width-auto uk-grid">
                    <label><input class="uk-checkbox" type="checkbox" id="disp" name="disp"> El producto está disponible.</label>
                </div>
                <div class="uk-margin">
                    <select class="uk-select" aria-label="Select" name="categoria" id="categoria">
                        <option value="">Seleccione una categoría.</option>
                        <option value="Coleccion">Artículo de colección</option>
                        <option value="Oficina">Artículo de oficina</option>
                        <option value="Belleza">Belleza.</option>
                        <option value="Miscelaneo">Misceláneo.</option>
                    </select>
                </div>
                <div class="uk-margin">
                    <select class="uk-select" aria-label="Select" name="tienda" id="tienda" multiple>
                        <optgroup label="Seleccione una o varias tiendas.">
<%     
    try{
        ArrayList<Tienda> al_TND = getTiendas(ds_CON);
        if(al_TND != null){
            for(Tienda tnd_BD: al_TND){
%>
                            <option value="<%= tnd_BD.getId_TND() %>"><%= tnd_BD.getNom_TND() %></option>
<%
            }
        } else {
%>
                            <option>Sin tiendas en la Base de Datos.</option>
<%
        }
    }catch (SQLException e) {
        System.err.println("Error en la conexión o consulta: " + e.getMessage());
    }
%>                                  
                        </optgroup>
                    </select>
                </div>
            </fieldset>
            <div class="uk-divider"></div>
            <div class="uk-fieldset uk-flex uk-container uk-container-xsmall uk-flex-column uk-flex-between@m uk-flex-row@m">
                <a class="uk-button uk-button-primary" id='crearProducto_BTN' href="javascript:void(0);" onclick="js_inProd(js_resModif);">Ingresar producto</a>
                <a class="uk-button uk-button-default" href="javascript:void(0);" onclick="js_FS000();">Limpiar campos</a>
                <a class="uk-button uk-button-danger" href="javascript:void(0);" onclick="js_FS004();">Anular ingreso</a>
            </div>
        </div>
        <button class="uk-modal-close-default" type="button" uk-close></button>
    </div>
<%
        if(idProd_REQ != null){
            int idProd_NUM = Integer.parseInt(idProd_REQ);
            //si no hay lista, indicar error al intentar actualizar.
            if(lp_OBJ != null){
                ListaProductos lp_SESS = (ListaProductos) lp_OBJ;
                //obtener el objeto y guardarlo en una variable de sesion independiente
                Producto prod_MODIF = lp_SESS.get(idProd_NUM);
                session.setAttribute("prod_MODIF", prod_MODIF);
                //los valores del form tendran la informacion del producto
%>
    <script>
        $(function(){
            $('#prod').val("<%= prod_MODIF.getNom() %>");
            $('#cant').val(<%= prod_MODIF.getCant() %>);
            $('#precio').val(<%= prod_MODIF.getPrecio() %>);
            $('#desc').val("<%= prod_MODIF.getDesc() %>");
            $('input[name="tipo"][value="<%= prod_MODIF.getTipo() %>"]').prop('checked', true);
            $('#disp').prop('checked',<%= prod_MODIF.getDisp() %> === 1);
            $('#categoria').val("<%= prod_MODIF.getCategoria() %>");
            
<%
            //ahora obtener las tiendas
            List<Tienda> tnd_ARR = prod_MODIF.getTiendas();
            if(tnd_ARR != null){
%>
            var js_tnd_ARR = [
<%
                    for(Tienda tnd: tnd_ARR){
%>
                        <%= tnd.getId_TND() %>,
<%
                    }
%>
            ];
            $('#tienda').val(js_tnd_ARR);
<%
            }
%>          
            $('#crearProducto_TIT').empty().html("Modificar producto.");
            $('#crearProducto_BTN').empty().html("Modificar producto.");
        });
    </script>
<%
            } else {
%>
    <script>
        $(function(){
            alert("Error al editar.");
        });
    </script>
<%
            }
        }
    }
%>

