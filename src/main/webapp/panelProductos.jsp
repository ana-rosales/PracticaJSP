<%@page contentType="text/html" pageEncoding="UTF-8" import="java.util.ArrayList,java.util.Arrays,java.io.IOException"%>
<%    
class Producto{
        private String prod,cant,precio,desc,tipo,disp,categoria;
        
        public Producto(String prod,String cant,String precio,String desc,String tipo,String disp,String categoria){
            this.prod = prod;
            this.cant = cant;
            this.precio = precio;
            this.desc = desc;
            this.tipo = tipo;
            this.disp = disp;
            this.categoria = categoria;
        }
        
        public String getProd(){
            return this.prod;
        }
        
        public String getCant(){
            return this.cant;
        }
        
        public String getPrecio(){
            return this.precio;
        }
        
        public String getDesc(){
            return this.desc;
        }
        
        public String getTipo(){
            return this.tipo;
        }
        
        public String getDisp(){
            return this.disp;
        }
        
        public String getCategoria(){
            return this.categoria;
        }
    }
    
    //arreglo para almacenar todos los productos
    ArrayList<Producto> productos = new ArrayList<>();    

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
    
%>

    <div class="uk-flex-top" id="vacio" uk-modal>
        <div class="uk-modal-dialog uk-modal-body uk-margin-auto-vertical">Campo vacío. <br /> Alguno de los campos está vacío. Por favor, vuelva a intentarlo.</div>
    </div>
    <div class="uk-flex-top" id="numerico-invalido" uk-modal>
        <div class="uk-modal-dialog uk-modal-body uk-margin-auto-vertical">Valor numérico inválido. <br /> La cantidad y el precio del producto no pueden ser negativos. Por favor, ingrese números válidos.</div>
    </div>

<%  
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

            //aquí el producto ES VÁLIDO
            //almacenar el producto en la lista
            Producto p = new Producto(prod,cant,precio,desc,tipo,disp,categoria);
            productos.add(p);
            
            //imprimir todos los productos en una tabla

%>

    <h1>Productos</h1>
    
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

<%          for (Producto e : productos) {
%>

            <tr>
                <td><%= e.getProd() %></td>
                <td><%= e.getCant() %></td>
                <td>$<%= e.getPrecio() %> MXN</td>
                <td><%= e.getDesc() %></td>
                <td><%= e.getTipo() %></td>
                <td>
                    <input class="uk-checkbox" type="checkbox" disabled>
<%              if(e.getDisp().equals("1")){
%>
<script>
    $(function(){ 
        $('input[type="checkbox"]').prop('checked', true);
    });
</script>
<%              }else{
%>
<script>
    $(function(){ 
        $('input[type="checkbox"]').prop('checked', false);
    });
</script>      
<%              }
%>
                    
                </td>
                <td><%= e.getCategoria() %></td>
            </tr>
<%          }
%>

        </tbody>
    </table>      
        
<%
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
