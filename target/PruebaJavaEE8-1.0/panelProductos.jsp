<%@page contentType="text/html" pageEncoding="UTF-8" import="
        com.apro.comercio.Producto,com.apro.db.ConectorBD,java.sql.SQLException,
        java.sql.ResultSet,java.sql.Connection,com.apro.db.APDataSource,
        java.sql.Statement,com.apro.comercio.Usuario,com.apro.comercio.ListaProductos,
        java.util.ArrayList,java.util.List,com.apro.comercio.Tienda"%>
<%!
   /**
     * Trae los productos de un usuario.
     * 
     * @param id_PARAM
     * @param ds_PARAM
     * @return
     * @throws SQLException 
     */
    public ListaProductos getProdUsu(int id_PARAM, APDataSource ds_PARAM) throws SQLException{
        
        //lista
        ListaProductos lp_RES = new ListaProductos();
        
        //conexion
        String qry_BD = "SELECT * FROM o_producto"
        + " WHERE c_i_usu = " + id_PARAM + " AND d_v_edo = 1";

        Connection con_POOL = ds_PARAM.getConnection();
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
            prod_TMP.setTiendas(ConectorBD.getTiendaProd(ID_NUM,ds_PARAM));
            
            lp_RES.add(prod_TMP);
        }
        
        stmt_CON.close();
        res_STMT.close();
        
        if(!tieneProd_USU){
            return null;
        } else {
            return lp_RES;
        }     
    }
%>
<%
    //Obtener el DataSource para consultar.
    APDataSource ds_CON = ConectorBD.getDataSource("negocio.properties");
    
    // SESSION
    Object usu_OBJ = session.getAttribute("usu_SESS");
    Object lp_OBJ = session.getAttribute("lp_SESS");
    Object ord_OBJ = session.getAttribute("ord_SESS");
    
    //request
    String str_PAG = request.getParameter("no_PAG");
    String str_ORD = request.getParameter("tipo_ORD");
    
    //paginacion
    int no_PROD = 200; //hardcodear por ahora
    int no_PAG = 1;
    int tipo_ORD = 1; //por default el orden es ascendente
    
    if(str_PAG != null){
        no_PAG = Integer.parseInt(str_PAG);
    }
    //ESTABLECER ORDEN
    
    //si se cambia el orden se guarda en variable de sesion
    if(str_ORD != null){
        tipo_ORD = Integer.parseInt(str_ORD);
        session.setAttribute("ord_SESS", tipo_ORD); 
    } 
    //si no se cambia y hay variable session, ese sera el orden
    else if(ord_OBJ != null){
        Integer ord_INT = (Integer) ord_OBJ;
        tipo_ORD = ord_INT; 
    }
    
    int pag_INI = (no_PAG-1) * no_PROD;
    int pag_FIN = no_PAG * no_PROD;
    
    //no se puede mostrar nada si no hay una sesion iniciada
    if(usu_OBJ != null){
        Usuario usu_SESS = (Usuario) usu_OBJ;
        ListaProductos lp_SESS = null;
        int id_USU = usu_SESS.getId_USU();
        
        //si no existe la lista de productos, se consulta y
        //se guarda en variable de sesion
        if(lp_OBJ == null){
            try{
                ListaProductos lp_USU = getProdUsu(id_USU, ds_CON);
                session.setAttribute("lp_SESS", lp_USU);
                lp_SESS = lp_USU;
            } catch (SQLException e) {
                System.err.println("Error en la conexion o consulta: " + e);
            }
        } else{
            lp_SESS = (ListaProductos) lp_OBJ;
        }
        System.out.println("Orden actual: " + tipo_ORD);
        //ordenar lista, tipo_ORD nunca sera diferente de 0 o 1.
        if(tipo_ORD == 1){ //ascendente
            lp_SESS.sort();
        } else { //descendente
            lp_SESS.sortReverse();
        }
        
        session.setAttribute("lp_SESS", lp_SESS);
        
        //obtener el numero de paginas
        Double pag_DOB = (double) lp_SESS.size() /no_PROD;
        pag_DOB = Math.ceil(pag_DOB);
%>
    <div class="uk-flex uk-flex-center uk-flex-between uk-flex-middle uk-width-1-1">
        <h2 class='uk-text-bold'><span class='uk-text-stroke'>Pro</span>ductos</h2>
        <a class="uk-button 
<%
        if(tipo_ORD == 1){
%>
            uk-button-primary
<%
        } else {
%>
            uk-button-default
<%
        }
%>
        " href="javascript:void(0);" onclick="js_traerProd(1,1);">Ascendente</a>
        <a class="uk-button 
<%
        if(tipo_ORD == 0){
%>
            uk-button-primary
<%
        } else {
%>
            uk-button-default
<%
        }
%>           
    " href="javascript:void(0);" onclick="js_traerProd(1,0);">Descendente</a>
    </div>
    
    <nav>
    <ul class="uk-pagination uk-flex uk-flex-between">
        <li class="uk-width-1-3 uk-flex uk-flex-left">
<%
    if(no_PAG > 1 && lp_SESS != null){
%>
            <a href="javascript:void(0);" onclick="js_traerProd(<%= no_PAG - 1 %>)">
                <span class="uk-margin-xsmall-right" uk-pagination-previous></span> Anterior
            </a>
        
<%
    }
%>      </li>
        <span class="uk-width-1-3 uk-flex uk-flex-center">
            <%= no_PAG %> / <%= pag_DOB.toString().substring(0, pag_DOB.toString().length()-2)%>
            (<%= lp_SESS.size() %> productos)
        </span>
        <li class="uk-width-1-3 uk-flex uk-flex-right">
<%
    if(no_PAG < pag_DOB && lp_SESS != null){
%>
        
            <a href="javascript:void(0);" onclick="js_traerProd(<%= no_PAG + 1 %>)">
                Siguiente <span class="uk-margin-xsmall-left" uk-pagination-next></span>
            </a>
        
<%
    }
%>      </li>
    </ul>
    </nav>    
    <div class="uk-overflow-auto">
        <table class="uk-table uk-table-striped uk-table-small uk-table-justify">
            <thead>
                <tr>
                    <th class='uk-text-center uk-text-secondary'>No.</th>
                    <th class='uk-text-center uk-text-secondary'>ID</th>
                    <th class='uk-text-center uk-text-secondary'>Nombre</th>
                    <th class='uk-text-center uk-text-secondary'>Cantidad</th>
                    <th class='uk-text-center uk-text-secondary'>Precio</th>
                    <th class='uk-text-center uk-text-secondary'>Descripción</th>
                    <th class='uk-text-center uk-text-secondary'>Tipo</th>
                    <th class='uk-text-center uk-text-secondary'>Disponible</th>
                    <th class='uk-text-center uk-text-secondary'>Categoría</th>
                    <th class='uk-text-center uk-text-secondary'>Tiendas</th>
                    <th class='uk-text-center uk-text-success'>Editar</th>
                    <th class='uk-text-center uk-text-danger'>Borrar</th>
                </tr>
            </thead>
            <tbody>
<%  
        if(lp_SESS.getProds() != null){
            if(pag_FIN > lp_SESS.size()){
                pag_FIN = lp_SESS.size();
            }
            for(int i = pag_INI; i < pag_FIN; i++){
                Producto prod_USU = lp_SESS.getIX(i);
%>
                <tr>
                    <td class='uk-padding-small uk-text-center'><%= i %></td>
                    <td class='uk-padding-small uk-text-center'><%= prod_USU.getId() %></td>
                    <td class='uk-padding-small uk-table-expand uk-text-center'><%= prod_USU.getNom() %></td>
                    <td class='uk-padding-small uk-text-center'><%= prod_USU.getCant() %></td>
                    <td class='uk-table-expand uk-text-center'>$<%= prod_USU.getPrecio() %> MXN</td>
                    <td class='uk-table-expand'><%= prod_USU.getDesc() %></td>
                    <td class='uk-text-center'><%= prod_USU.getTipo() %></td>
                    <td class='uk-text-center'>
<%
                if(prod_USU.getDisp() == 1){
%>              
                        <input class="uk-checkbox tabla" type="checkbox" disabled checked>
<%
                } else {
%>
                        <input class="uk-checkbox tabla" type="checkbox" disabled>
<%
                }
%>
                    </td>
                    <td class='uk-text-center'><%= prod_USU.getCategoria() %></td>
                    <td class='uk-table-expand'>
<%              
                if(prod_USU.getTiendas() != null){
                    for(Tienda tienda_PROD:prod_USU.getTiendas()){
%>
                        <span class="uk-badge"><%= tienda_PROD.getNom_TND() %></span>
<%                          
                    }
                } else {
%>
                        Sin tienda.
<%                            
                }
%>
                    </td>
                    <td>
                        <a class="uk-text-success" uk-icon="icon: pencil" 
                    href="javascript:void(0);" onclick="js_formProd(<%= prod_USU.getId() %>);">
                        </a>
                    </td>
                    <td>
                        <a class="uk-text-danger" uk-icon="icon: trash" 
                        href="javascript:void(0);" onclick="js_delProd(<%= prod_USU.getId() %>,js_resDel);">
                        </a>
                    </td>
                </tr>
<%      
            }
        }else{
%>
                <tr><td colspan="10"><p>Aún no se registra ningún producto.</p></td></tr> 
<%
        }
%>
            </tbody>
        </table>
    </div>
<%
    } else {
%>
    <p>No hay sesion iniciada.</p>
<%
    }
%>
