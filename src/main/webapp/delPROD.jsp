<%@page import="com.apro.comercio.Producto"%>
<%@page import="com.apro.comercio.ListaProductos"%>
<%@page contentType="text/html" pageEncoding="UTF-8" import="
    java.sql.SQLException,com.apro.db.ConectorBD,com.apro.db.APDataSource" %>
<%
    //Obtener el DataSource para consultar.
    APDataSource ds_CON = ConectorBD.getDataSource("negocio.properties");

    // request
    String idProd_REQ = request.getParameter("idProd");
    int idProd_NUM = Integer.parseInt(idProd_REQ);
    
    // SESSION
    Object usu_OBJ = session.getAttribute("usu_SESS");
    Object lp_OBJ = session.getAttribute("lp_SESS");
    
    //valor eliminado logico
    int valDel = 1;
    
    //si no hay sesion no se hace nada
    if(usu_OBJ != null){
        try{
            //borrar maestro
            int resDelMtr = ConectorBD.delProdMast(idProd_NUM, ds_CON);
            if(resDelMtr > 0){
                System.out.println("exito al eliminar.");
            }

            //borrar detalles
            int resDelDet = ConectorBD.delProdMast(idProd_NUM, ds_CON);
            if(resDelDet > 0){
                System.out.println("exito al eliminar.");
            }
            valDel = 0;
            //se obtiene el producto de la lista, si no
            //hubo error al eliminar
            if(lp_OBJ != null){
                ListaProductos lp_SESS = (ListaProductos) lp_OBJ;
                boolean prod_DEL = lp_SESS.deleteWithID(idProd_NUM);
                session.removeAttribute("lp_SESS");
                session.setAttribute("lp_SESS", lp_SESS);
                if(!prod_DEL){
%>
                <script>
                    $(function(){
                        alert("Error al eliminar.");
                    });
                </script>
<%
                }
            } else {
%>
                <script>
                    $(function(){
                        alert("Error al eliminar.");
                    });
                </script>
<%
            }
        } catch (SQLException e){            
            System.err.println("Error en la conexión o consulta: " + e.getMessage());
        }
    }
%>
<input type="hidden" id="resDel" value=<%= valDel %>>