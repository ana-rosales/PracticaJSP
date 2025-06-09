<%@page contentType="text/html" pageEncoding="UTF-8" import="
        com.apro.comercio.Usuario"%>
<%
    //Intenta obtener usuario de la sesion.
    Object usu_OBJ = session.getAttribute("usu_SESS");
    
    //Variable para almacenar el resultado de validacion.
    int haySess_RES;    
    if(usu_OBJ != null){
        haySess_RES = 1;
    } else {
        haySess_RES = 0;
    }
        
%>
<input type="hidden" id="haySess" value=<%= haySess_RES %>>

