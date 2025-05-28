<%@page import="java.sql.SQLException"%>
<%@page import="com.apro.db.ConectorBD"%>
<%@page import="com.apro.db.APDataSource"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    //Obtener el DataSource para consultar.
    String usu_BD = "root", 
            pwd_BD = "admin", 
            base_BD = "negocio", 
            driver_BD = "org.mariadb.jdbc.Driver",
            url_BD = "jdbc:mariadb://localhost:3360/";    
    APDataSource ds_CON = ConectorBD.getDataSource(usu_BD, pwd_BD, base_BD, driver_BD, url_BD);

    // request
    String idProd_REQ = request.getParameter("idProd");
    int idProd_NUM = Integer.parseInt(idProd_REQ);
    
    // SESSION
    Object usu_OBJ = session.getAttribute("usu_SESS");
    
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
        } catch (SQLException e){            
            System.err.println("Error en la conexión o consulta: " + e.getMessage());
        }
    }
%>
<input type="hidden" id="resDel" value=<%= valDel %>>