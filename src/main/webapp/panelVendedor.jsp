<%@page contentType="text/html" pageEncoding="UTF-8" import="
        com.apro.comercio.Usuario"%>
<%
    //Intenta obtener usuario de la sesion.
    Usuario usu_OBJ = (Usuario) session.getAttribute("usu_SESS");
    
    //no se puede mostrar nada si no hay una sesion iniciada
    if(usu_OBJ != null){
        String nom_USU = usu_OBJ.getNom_USU();
%>
        <div class="uk-divider"></div>
        <div class="uk-container uk-container-expand uk-flex uk-flex-column uk-flex-between@s uk-flex-row@s">
            <h1 class="uk-text-center uk-text-bold uk-margin-auto-vertical uk-margin-remove@s">
                Bienvenido <span class='uk-text-stroke'><%= nom_USU %></span>
            </h1>
            <div class="uk-flex uk-flex-column-reverse uk-flex-column@s">
                <a id='cerrarSesion_BTN' class="uk-button uk-button-danger uk-margin-bottom" href="javascript:void(0);" onclick="js_cerrarSess(js_resCerrar);">Cerrar sesión</a>
                <a id='formCrear_BTN' class="uk-button uk-button-primary" href="javascript:void(0);" onclick="js_formProd();">Ingresar producto</a>
            </div>
        </div>
        <hr />
<%
    } else {
%>
        <p>No hay sesion iniciada.</p>
<%
    }
%>
