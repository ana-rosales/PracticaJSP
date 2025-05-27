<%@page contentType="text/html" pageEncoding="UTF-8" import="
        com.apro.comercio.Usuario"%>
<%
    //Intenta obtener usuario de la sesion.
    Usuario usu_OBJ = (Usuario) session.getAttribute("usu_SESS");
    
    //Variable para almacenar el resultado de validacion.
    int haySess_RES;    
    if(usu_OBJ != null){
    
        System.out.println("Hay sesion");
        haySess_RES = 1;
    } else {
        System.out.println("No hay sesion");
        haySess_RES = 0;
    }
        
%>
<input type="hidden" id="haySess" value=<%= haySess_RES %>>

