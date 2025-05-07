<%@page contentType="text/html" pageEncoding="UTF-8" import="java.util.ArrayList,java.util.Arrays,java.io.IOException"%>
<%
    System.out.println("--------------------");
    //obtener campos encapsulados en el post
    String prod = request.getParameter("prod"),
    cant = request.getParameter("cant"),
    precio = request.getParameter("precio"),
    desc = request.getParameter("desc"),
    tipo = request.getParameter("tipo"),
    disp = request.getParameter("disp"),
    categoria = request.getParameter("categoria"),
    productos = request.getParameter("productos");
    
    //la disponibilidad puede ser nula
    if(disp == null){
        disp = "0";
    }
    
    //se obtiene cuantos productos se han ingresado
    Integer numProductos = Integer.parseInt(productos);
    
    //validar campos vacios
    if(prod.equals("") || cant.equals("") || precio.equals("") || desc.equals("") || tipo == null || categoria.equals("")){
%>
        <script>
            $(function(){ 
                UIkit.modal('#vacio').show();
            });
        </script>
<%    
    } else {
        //validar campos numericos
        int numCant = Integer.parseInt(cant);
        float numPrecio = Float.parseFloat(precio);

        if(numCant >= 0 && numPrecio >= 0){
            System.out.println("Disponibilidad al imprimir tabla: " + disp);
            //aquí el producto ES VÁLIDO
            if(numProductos == 0){
%>
                <h2>Productos</h2>
                
                <div class="uk-overflow-auto">
                    <table class="uk-table uk-table-striped">
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
<%              if(disp.equals("1")){
%>
                    <input id="disp<%= productos %>" class="tabla uk-checkbox" type="checkbox" checked disabled>
<%              }else{
%>                  
                    <input id="disp<%= productos %>" class="tabla uk-checkbox" type="checkbox" disabled> 
<%              }
%>
                                </td>
                                <td><%= categoria %></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="uk-divider"></div>
<%          } else {
%>              

                <tr>
                    <td><%= prod %></td>
                    <td><%= cant %></td>
                    <td>$<%= precio %> MXN</td>
                    <td><%= desc %></td>
                    <td><%= tipo %></td>
                    <td>
<%              if(disp.equals("1")){
%>                 
                    <input id="disp<%= productos %>" class="tabla uk-checkbox" type="checkbox" checked disabled>
                    
<%              }else{
%>                  
                    <input id="disp<%= productos %>" class="tabla uk-checkbox" type="checkbox" disabled>
<%              }
%>
                    </td>
                    <td><%= categoria %></td>
                </tr>

<%
            }
            numProductos = numProductos+1;
            productos = String.valueOf(numProductos);
        } else {
%>

            <script>   
                $(function(){ 
                    UIkit.modal('#numerico-invalido').show();
                });	
            </script>         

<%
        }
    }
%>
<input type="hidden" id="productos" value="<%= numProductos %>">
