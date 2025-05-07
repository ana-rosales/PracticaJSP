<%@page contentType="text/html" pageEncoding="UTF-8" %>
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
        $('#fondo').show();
    });	
</script> 
<%
    } else {
        //validar usuario
        boolean exito = validaUsu(usu,contra);
        if(exito){
%>

    <script>
        $(function(){ 
            $("#fondo").hide();
        });
    </script>
    <div class="uk-divider"></div>
    <div class="uk-container uk-container-expand uk-flex uk-flex-column uk-flex-between@s uk-flex-row@s">
        <h1 class="uk-text-center uk-margin-small-top uk-margin-medium-bottom uk-margin-remove@s">Bienvenido <%= usu %></h1>
        <div class="uk-flex uk-flex-column-reverse uk-flex-column@s">
            <a class="uk-button uk-button-danger" href="javascript:void(0);" onclick="js_FS003();">Cerrar sesión</a>
            <a class="uk-button uk-button-primary" href="javascript:void(0);" onclick="js_FS002();">Ingresar producto</a>
        </div>
    </div>
    <hr />

<%
        } else {
%>
<script>   
    $(function(){ 
        UIkit.modal('#usuario-invalido').show();
        $('#fondo').show();
    });	
</script> 
<%
        }
    }
%>
        
    </body>
</html>
