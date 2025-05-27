<%@page import="java.util.ArrayList"%>
<%@page import="com.apro.comercio.ListaProductos"%>
<%@page import="com.apro.comercio.Usuario"%>
<%@page import="java.sql.Statement"%>
<%@page import="com.apro.db.APConnection"%>
<%@page import="com.apro.db.APDataSource"%>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@page import="com.apro.comercio.Producto,com.apro.db.ConectorBD,java.sql.SQLException,java.sql.ResultSet,java.sql.Connection"%>
<%
    //Obtener el DataSource para consultar.
    String usu_BD = "root", 
            pwd_BD = "admin", 
            base_BD = "negocio", 
            driver_BD = "org.mariadb.jdbc.Driver",
            url_BD = "jdbc:mariadb://localhost:3360/";    
    APDataSource ds_CON = ConectorBD.getDataSource(usu_BD, pwd_BD, base_BD, driver_BD, url_BD);
    
    // SESSION
    Usuario usu_OBJ = (Usuario) session.getAttribute("usu_SESS");
    
    //no se puede mostrar nada si no hay una sesion iniciada
    if(usu_OBJ != null){
        int id_USU = usu_OBJ.getId_USU();
    
%>
        <h2 class='uk-text-bold'><span class='uk-text-stroke'>Pro</span>ductos</h2>
        <div class="uk-overflow-auto">
            <table class="uk-table uk-table-striped uk-table-small uk-table-justify uk-margin-medium-bottom">
                <thead>
                    <tr>
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
        try {
            ListaProductos lp_USU = ConectorBD.getProdUsu(id_USU, ds_CON);
            if(lp_USU != null){
                for(Producto prod_USU: lp_USU.getProds()){
%>
                    <tr>
                        <td class='uk-text-center'><%= prod_USU.getNom() %></td>
                        <td class='uk-text-center'><%= prod_USU.getCant() %></td>
                        <td class='uk-text-center'>$<%= prod_USU.getPrecio() %> MXN</td>
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
                    try{
                        ArrayList<String> al_TND = ConectorBD.getTiendaProd(prod_USU.getId(), ds_CON);
                        if(al_TND != null){
                            for(String tienda_PROD:al_TND){
%>
                            <span class="uk-badge"><%= tienda_PROD %></span>
<%                          
                            }
                        } else {
%>
                            Sin tienda.
<%                            
                        }
                    }catch(SQLException e){
                        System.err.println("Error en la conexión o consulta: " + e.getMessage());
                    }
%>
                        </td>
                        <td>
                            <a class="uk-text-success" uk-icon="icon: pencil" 
                        href="javascript:void(0);" onclick="
                        js_FS010(<%= prod_USU.getId() %>,'<%= prod_USU.getNom() %>',
                        <%= prod_USU.getCant() %>,<%= prod_USU.getPrecio() %>,
                        '<%= prod_USU.getDesc().replace("\n", " ").replace("\r", " ").replace("'", "\\'").replace("\"", "\\\"") %>',
                        '<%= prod_USU.getTipo() %>',<%= prod_USU.getDisp() %>,
                        '<%= prod_USU.getCategoria() %>');">
                            </a>
                        </td>
                        <td>
                            <a class="uk-text-danger" uk-icon="icon: trash" 
                            href="javascript:void(0);" onclick="js_FS009(<%= prod_USU.getId() %>);">
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
        } catch (SQLException e) {
            System.err.println("Error en la conexión o consulta: " + e.getMessage());
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
