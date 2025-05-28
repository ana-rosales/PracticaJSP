<%@page import="com.apro.comercio.Usuario"%>
<%@page import="com.apro.comercio.Producto"%>
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
    
    //Obtener los datos encapsulados en el POST.
    String idProd_REQ = request.getParameter("idProd");
    int idProd_NUM = Integer.parseInt(idProd_REQ);
    
    //valor consulta
    int valorConsulta = 1;
    
    // SESSION
    Object usu_OBJ = session.getAttribute("usu_SESS");
    
    //no se ejecuta nada si no hay una sesion iniciada
    if(usu_OBJ != null){
    
        try{
            Producto prod_MODIF = ConectorBD.getProducto(idProd_NUM, ds_CON);
            if(prod_MODIF != null){
                valorConsulta = 0;
                // se guarda el id del producto para su modificacion.
                session.setAttribute("idProd_MODIF", prod_MODIF.getId());
                //procesar el nombre y la descripcion
                String nomProd_MODIF = prod_MODIF.getNom();
                String descProd_MODIF = prod_MODIF.getDesc();
            
%>
                <%-- datos para los valores de los inputs en el form --%>
                <input type="hidden" id="nomProd" value="<%= nomProd_MODIF %>">
                <input type="hidden" id="cantProd" value=<%= prod_MODIF.getCant() %>>
                <input type="hidden" id="precioProd" value=<%= prod_MODIF.getPrecio() %>>
                <input type="hidden" id="descProd" value="<%= descProd_MODIF %>">
                <input type="hidden" id="tipoProd" value="<%= prod_MODIF.getTipo() %>">
                <input type="hidden" id="dispProd" value="<%= prod_MODIF.getDisp() %>">
                <input type="hidden" id="categoProd" value="<%= prod_MODIF.getCategoria()%>">
<%
            }
        }catch (SQLException e) {
            System.err.println("Error en la conexión o consulta: " + e.getMessage());
        }
    }
%>
<input type="hidden" id="resObt" value=<%= valorConsulta %>>

