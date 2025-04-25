<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Vendedor</title>
    </head>
    <body>
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

    <h1>Campo vacío.</h1>
    <p>Alguno de los campos está vacío. Por favor, vuelva a intentarlo.</p>
    <button onclick="location.href='index.html'">Regresar al formulario</button>

<%
    } else {
        //validar usuario
        boolean exito = validaUsu(usu,contra);
        if(exito){
%>

    <button onclick="location.href='index.html'">Cerrar sesión.</button>
    <h1>Bienvenido <%= usu %></h1>
    <button onclick="location.href='producto.html'">Ingresar producto.</button>

<%
        } else {
%>

    <h1>Usuario inválido.</h1>
    <p>El usuario o la contraseña indicados son erróneos. Por favor, vuelva a intentarlo.</p>
    <button onclick="location.href='index.html'">Regresar al formulario</button>
    
<%
        }
    }

    
%>
        
    </body>
</html>
