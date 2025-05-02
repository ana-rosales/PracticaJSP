<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Vendedor</title>
    </head>
    <body>
        <div class="uk-flex-top" id="vacio" uk-modal>
            <div class="uk-modal-dialog uk-modal-body uk-margin-auto-vertical">Campo vacío. <br /> Alguno de los campos está vacío. Por favor, vuelva a intentarlo.</div>
        </div>
        <div class="uk-flex-top" id="usuario-invalido" uk-modal>
            <div class="uk-modal-dialog uk-modal-body uk-margin-auto-vertical">Usuario inválido. <br /> El usuario o la contraseña indicados son erróneos. Por favor, vuelva a intentarlo.</div>
        </div>
<%! 
    //SCRIPLET -> funje como clase para evitar crear una.
    
    //Método para validar al usuario.
    public boolean validaUsu(String usu, String contra){
        boolean ok = false;
        if(usu.equals("admin") && contra.equals("data123456")){
            ok = true;
        }
        return ok;
    }

%>
<%
    //Obtener los datos encapsulados en el POST
    String usu = request.getParameter("nom"),
    contra = request.getParameter("pwd");
    
    //Validar no vacíos
    if(usu.equals("") || contra.equals("")){
%>
<script>   
    $(function(){ 
        UIkit.modal('#vacio').show();
    });	
</script> 
<%
    } else {
        //validar usuario
        boolean exito = validaUsu(usu,contra);
        if(exito){
%>
    <div class="uk-container uk-flex uk-flex-between">
        <h1>Bienvenido <%= usu %></h1>
        <div class="uk-flex uk-flex-column">
            <a class="uk-button uk-button-primary" href="javascript:void(0);" onclick="js_FS003();">Cerrar sesión</a>
            <a class="uk-button uk-button-default" href="javascript:void(0);" onclick="js_FS002();">Ingresar producto</a>
        </div>
    </div>
    <hr />

<%
        } else {
%>
<script>   
    $(function(){ 
        UIkit.modal('#usuario-invalido').show();
    });	
</script> 
<%
        }
    }
%>
        
    </body>
</html>
