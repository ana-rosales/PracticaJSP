<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Productos</title>
    </head>
    <body>
<%
    //obtener campos encapsulados en el post
    String prod = request.getParameter("prod"),
    cant = request.getParameter("cant"),
    precio = request.getParameter("precio"),
    desc = request.getParameter("desc"),
    tipo = request.getParameter("tipo"),
    disp = request.getParameter("disp"),
    categoria = request.getParameter("categoria");
    
    //la disponibilidad puede ser nula
    if(disp == null){
        disp = "0";
    }
    
    //validar campos vacios
    if(prod.equals("") || cant.equals("") || precio.equals("") || desc.equals("") || tipo == null || categoria == null){
%>

        <h1>Campo vacío.</h1>
        <p>Alguno de los campos está vacío. Por favor, vuelva a intentarlo.</p>
        <button onclick="location.href='producto.html'">Regresar al formulario</button>
        
<%    
    } else {
        //validar campos numericos
        int numCant = Integer.parseInt(cant);
        float numPrecio = Float.parseFloat(precio);

        if(numCant >= 0 && numPrecio >= 0){
%>

        <h1>Productos</h1>
        <form action="panelVendedor.jsp" method="post">
            <input type="hidden" name="nom" id="nom" value="admin"/>
            <input type="hidden" name="pwd" id="pwd" value="data123456"/>
            <input type="submit" value="Volver al inicio" />
        </form>
        
        <table>
            <thead>
                <tr>
                    <th>Nombre del producto</th>
                    <th>Cantidad</th>
                    <th>Precio</th>
                    <th>Descripción</th>
                    <th>Tipo</th>
                    <th>Disponible</th>
                    <th>Categoría</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><%= prod %></td>
                    <td><%= cant %></td>
                    <td>$<%= precio %> MXN</td>
                    <td><%= desc %></td>
                    <td><%= tipo %></td>
                    <td>
                        <input type="checkbox" disabled
<%
            if(disp.equals("1")){
%>

                        checked
                               
<%
            }
%>
                        >
                    </td>
                    <td><%= categoria %></td>
                </tr>
            </tbody>
        </table>  
        <button onclick="location.href='producto.html'">Ingresar otro producto</button>      
        
<%
        } else {
%>

        <h1>Valor numérico inválido.</h1>
        <p>La cantidad y el precio del producto no pueden ser negativos. Por favor, ingrese números válidos.</p>
        <button onclick="location.href='producto.html'">Regresar al formulario</button>
        
<%
        }
    }
%>
        
    </body>
</html>
