<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@page import="java.util.ArrayList,java.util.Arrays,java.io.IOException,com.apro.comercio.Producto,com.apro.comercio.ListaProductos,com.apro.db.ConectorDB,java.sql.SQLException,java.sql.ResultSet,java.sql.Connection"%>
<%
    ConectorDB.cargarDriver_BD("org.mariadb.jdbc.Driver");
    
    // REQUEST
    String in_jvs_inprod = request.getParameter("msg_jsv_inprod");
    String in_jvs_borrar = request.getParameter("msg_jsv_borrar");
    
    // SESSION
    Integer usuID_BD = (Integer) session.getAttribute("usu_SESS");
    
    System.out.println("El usuario actual tiene id: " + session.getAttribute("usu_SESS"));
    
    if (usuID_BD == null) {
        System.out.println("Error: el usuario no está autenticado");
        usuID_BD = -1;
    }
    
    // Obtener la lista de productos desde la sesión
    ListaProductos amc_jvo_prods = (ListaProductos) session.getAttribute("listaProductos");

    // Si no existe, crearla
    if (amc_jvo_prods == null) {
        amc_jvo_prods = new ListaProductos();
    }
    
    // Codigo para crear un objeto producto e ingresarlo a una lista.
    if(("1").equals(in_jvs_inprod)) {
        
        //obtener campos encapsulados en el post
        String usu_REQ = request.getParameter("usu"),
        prod = request.getParameter("prod"),
        cant = request.getParameter("cant"),
        precio = request.getParameter("precio"),
        desc = request.getParameter("desc"),
        tipo = request.getParameter("tipo"),
        disp = request.getParameter("disp"),
        categoria = request.getParameter("categoria");
        
        //Disponibilidad.
        int disp_INT;
        if(disp.equals("0")){
            disp_INT = 0;
        } else {
            disp_INT = 1;
        }

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
            float tmp_jvf_precio = Float.parseFloat(precio);
            int tmp_jvi_cant;

            try{
                tmp_jvi_cant = Integer.parseInt(cant);
            } catch (NumberFormatException nfe){
                tmp_jvi_cant = -1;     
            }

            if(tmp_jvi_cant >= 0 && tmp_jvf_precio >= 0){
                //aquí el producto ES VÁLIDO
                //aquí se crea el objeto
                Producto amc_jvo_prod = new Producto();
                amc_jvo_prod.setNom(prod);
                amc_jvo_prod.setDesc(desc);
                amc_jvo_prod.setTipo(tipo);
                amc_jvo_prod.setCategoria(categoria);
                amc_jvo_prod.setPrecio(tmp_jvf_precio);
                amc_jvo_prod.setCant(tmp_jvi_cant);
                amc_jvo_prod.setDisp(disp_INT);
                
                // Agregarlo a la BASE
                try (Connection conexion_BD = ConectorDB.crearConexion_BD()) {
                    
                    String insertar_BD = "insert into o_producto (c_i_usu,n_v_nombre,d_v_cant,d_v_precio,d_v_desc,d_v_tipo,d_v_disp,d_v_catego)" + 
                                            "values ('" + usuID_BD + "','" + prod + "','" + tmp_jvi_cant + "','" + tmp_jvf_precio + "','" + desc + "','" + tipo + "','" + disp_INT + "','" + categoria + "');";
                    int insertar = ConectorDB.insertar_BD(insertar_BD,conexion_BD);

                    if(insertar > 0){
                        System.out.println("exito registro");
                    }

                } catch (SQLException e) {
                    System.err.println("Error en la conexión o consulta: " + e.getMessage());
                }

                amc_jvo_prods.cfg_jmv_add(amc_jvo_prod);
                // Guardar la lista en la sesión
                session.setAttribute("listaProductos", amc_jvo_prods);
%>
                <%--<script>
                    $(function(){ 
                        UIkit.modal('#out_hm_exito').show();
                    });
                </script>
                
                <!-- Este modal puede ir en index.html -->
                
                <div id="out_hm_exito" uk-modal>
                    <div class="uk-modal-dialog uk-margin-auto-vertical uk-background-secondary uk-light">
                        <div class="uk-modal-header uk-background-secondary uk-light">
                            <h2 class="uk-modal-title">Registro exitoso.</h2>
                        </div>
                        <div class="uk-modal-body">El producto fue registrado exitosamente.</div>
                        <button class="uk-modal-close-default" type="button" uk-close></button>
                    </div>
                </div>--%>
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
    }

    // codigo para borrar producto de la base
    if(in_jvs_borrar != null && !in_jvs_borrar.isEmpty()){
        int tmp_jvi_borrar = Integer.parseInt(in_jvs_borrar);

        try (Connection conexion = ConectorDB.crearConexion_BD()) {
            String sql = "delete from o_producto where c_i_clave = " + tmp_jvi_borrar;
            int borrar = ConectorDB.insertar_BD(sql,conexion);

            if(borrar > 0){
                System.out.println("exito al eliminar.");
            }

        } catch (SQLException e) {
            System.err.println("Error en la conexión o consulta: " + e.getMessage());
        }
    }
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
                    <th><strong>Borrar</strong></th>
                </tr>
            </thead>
            <tbody>
<%  
    try (Connection conexion = ConectorDB.crearConexion_BD()) {
        ResultSet resultado = ConectorDB.consultar_BD("SELECT * FROM o_producto WHERE c_i_usu = " + usuID_BD ,conexion);

        boolean tieneProd_USU = false;
        while (resultado.next()) {
                tieneProd_USU = true;
                
                String ID_PROD = resultado.getString("c_i_clave"), /// porque ahorra tiempo de procesamiento
                nom_PROD = resultado.getString("n_v_nombre"),
                cant_PROD = resultado.getString("d_v_cant"),
                precio_PROD = resultado.getString("d_v_precio"),
                tipo_PROD = resultado.getString("d_v_tipo"),
                desc_PROD = resultado.getString("d_v_desc"),
                disp_PROD = resultado.getString("d_v_disp"),
                catego_PROD = resultado.getString("d_v_catego");

                int cant_NUM, disp_NUM, ID_NUM;
                float precio_NUM = Float.parseFloat(precio_PROD);
                try{
                    ID_NUM = Integer.parseInt(ID_PROD);
                    cant_NUM = Integer.parseInt(cant_PROD);
                    disp_NUM = Integer.parseInt(disp_PROD);
                } catch (NumberFormatException nfe){
                    ID_NUM = -1;
                    cant_NUM = -1;    
                    disp_NUM = -1;     
                }

                System.out.println(resultado.getString(1) + " - " + resultado.getString(2));

%>
                <tr>
                    <th><%= nom_PROD %></th>
                    <th><%= cant_NUM %></th>
                    <th><%= precio_NUM %></th>
                    <th><%= desc_PROD %></th>
                    <th><%= tipo_PROD %></th>
                    <th>
<%
                if(disp_NUM == 1){
%>              
                        <input class="uk-checkbox" type="checkbox" disabled checked>
<%
                } else {
%>
                        <input class="uk-checkbox" type="checkbox" disabled>
<%
                }
%>
                    </th>
                    <th><%= catego_PROD %></th>
                    <th><a uk-icon="icon: trash" href="javascript:void(0);" onclick="js_FS009(<%= ID_NUM %>);"></a></th>
                </tr>
<%      
        }
        if(!tieneProd_USU){
%>
                <tr><th colspan="8"><p>Aún no se registra ningún producto.</p></th></tr>       
<%      }
    } catch (SQLException e) {
        System.err.println("Error en la conexión o consulta: " + e.getMessage());
    }
%>
            </tbody>
        </table>
    </div>
