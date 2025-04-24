<%@page contentType="text/html" pageEncoding="UTF-8" import="java.io.*"%>
<!DOCTYPE html>
<%!
    public boolean m_Valida(String i_User, String i_Pwd){
        boolean l_resultado = false;

        if(i_User.equals("admin") && i_Pwd.equals("data123456")){
            l_resultado = true;
        }
        return l_resultado;
    }
%>
<%
    String l_u = request.getParameter("nom"), l_p = request.getParameter("pwd");

    if(l_u == null || l_p == null){
%>

    <p>Redirigiendo a inicio, usuario o contraseña VACÍOS.</p>
    <a href="index.html">Formulario inicio.</a>
    
<%   
    } else {
        boolean l_exito = m_Valida(l_u, l_p);

        if(l_exito)  {
%>

    <h1>Bienvenido <%= l_u %>.</h1>

<% 
        } else {
%>

    <p>Redirigiendo a inicio, usuario y contraseña INCORRECTOS.</p>
    <a href="index.html">Formulario inicio.</a>

<% 
        }       
    }
%>