<%@page contentType="text/html" pageEncoding="UTF-8" import="
        com.apro.comercio.Usuario"%>
<%
    //Intenta obtener usuario de la sesion.
    Object usu_OBJ = session.getAttribute("usu_SESS");
    
    //estado de cerrar sesion
    int edoCerrar_SESS = 1;
    
    //solo se cierra sesion cuando hay una sesion iniciada.  
    if(usu_OBJ != null){
        session.invalidate();
        edoCerrar_SESS = 0;
        //se cierra sesion exitosamente
    }      
%>
<input type="hidden" id="cerrarSess" value=<%= edoCerrar_SESS %>>
