<%@page contentType="text/html" pageEncoding="UTF-8" import="java.io.*"%>
<!DOCTYPE html>
<head>
    <style>
        body{
                color: saddlebrown;
                margin: 0;
                display: flex;
                justify-content: center;
        }
        table{
            border-collapse: collapse;
        }
        table,th,td{
            border: saddlebrown solid 1px;
        }
        th,td{
            padding: 1rem;
        }
        .container {
            display:block;
            margin: 5vh 0;
            padding: 5vh;
            width: 90vw;
            height: 100%;
            border: saddlebrown solid 1px;
            border-radius: 5px;
        }
        button{
            margin: 1rem 0;
        }
    </style>
</head>
<body>
    <div class="container">
<%!
    //scriplet para validar usuario
    public boolean m_ValidaUsu(String i_User, String i_Pwd){
        boolean l_resultado = false;

        if(i_User.equals("admin") && i_Pwd.equals("data123456")){
            l_resultado = true;
        }
        return l_resultado;
    }
%>
<%
    //obtener los campos del POST
    String a_prod = request.getParameter("a_prod"),
            a_cant = request.getParameter("a_cant"),
            a_precio = request.getParameter("a_precio"),
            a_tipo = request.getParameter("a_tipo"),
            a_disp = request.getParameter("a_disp"),
            a_desc = request.getParameter("a_desc"),
            a_categoria = request.getParameter("a_categoria");
            
    //la disponibilidad puede ser negativa
    if(a_disp == null){
        a_disp = "";
    }            
            
    //validar campos vacios
    if(a_prod.equals("") || a_cant.equals("") || a_precio.equals("") || a_tipo == null ||
    a_desc.equals("") || a_categoria.equals("")){
%>

        <h1>Campo vacío.</h1>
        <p>Algún campo está vacío. Por favor, revise la información.</p>
        <a href="index.html">Regresar al formulario.</a>
    
<%
    //ningun campo es vacio
    } else {
        //validar cantidad y precio de producto no negativa
        int cant = Integer.parseInt(a_cant);
        float precio = Float.parseFloat(a_precio);
        if(cant >= 0 && precio >= 0){
%>
        <h1>Productos:</h1>

        <table>
            <thead>
                <tr>
                    <th>Producto</th>
                    <th>Cantidad</th>
                    <th>Precio</th>
                    <th>Tipo</th>
                    <th>Disponible</th>
                    <th>Descripción</th>
                    <th>Categoría</th> 
                </tr>
            <thead>
            <tbody>
                <tr>
                    <td><%= a_prod %></td>
                    <td><%= a_cant %></td>
                    <td>$<%= a_precio %> MXN</td>
                    <td><%= a_tipo %></td>
                    <td>
                        <input type="checkbox" disabled
<%
            if(a_disp.equals("on")){
%>
                            checked
<%
            }
%>
                        >
                    </td>
                    <td><%= a_desc %></td>
                    <td><%= a_categoria %></td>
                </tr>
            </tbody>
        </table>
        <button onclick="location.href = 'index.html'">Ingresar otro producto.</button>

<%
        } else {
%>
        
        <h1>Valor numérico inválido.</h1>
        <p>La cantidad y el precio del producto no pueden ser negativos.</p>
        <p>Por favor, ingrese valores válidos.</p>
        <a href="index.html">Regresar al formulario.</a>

<%
        }
    }
%>
    </div>
</body>