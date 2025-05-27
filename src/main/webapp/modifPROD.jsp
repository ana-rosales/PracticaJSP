<%@page import="com.apro.comercio.Usuario"%>
<%@page import="java.sql.Statement"%>
<%@page import="com.apro.db.APConnection"%>
<%@page import="com.apro.db.APDataSource"%>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@page import="com.apro.comercio.Producto,com.apro.db.ConectorBD,java.sql.SQLException,java.sql.ResultSet,java.sql.Connection"%>
<%
    //Obtener el DataSource para consultar.
    String usu_BD = "root", 
            pwd_BD = "admin", 
            base_BD = "negocio", 
            driver_BD = "org.mariadb.jdbc.Driver",
            url_BD = "jdbc:mariadb://localhost:3360/";    
    APDataSource ds_CON = ConectorBD.getDataSource(usu_BD, pwd_BD, base_BD, driver_BD, url_BD);
    
    // SESSION
    Usuario usu_OBJ = (Usuario) session.getAttribute("usu_SESS");
    
    //no se puede mostrar nada si no hay una sesion iniciada
    if(usu_OBJ != null){
    
    // REQUEST
    String in_jvs_inprod = request.getParameter("msg_jsv_inprod");
    String in_jvs_borrar = request.getParameter("msg_jsv_borrar");
    String in_jvs_modificar = request.getParameter("modificar_MSG");
    
    
    
    System.out.println("El usuario actual tiene id: " + session.getAttribute("usu_SESS"));
    
    if (usuID_BD == null) {
        System.err.println("Error: el usuario no está autenticado");
        usuID_BD = -1;
    }
    
    // Codigo para crear un objeto producto e ingresarlo a la base.
    if(("1").equals(in_jvs_inprod)) {
        
        //obtener campos encapsulados en el post
        String prod = request.getParameter("prod"),
        cant = request.getParameter("cant"),
        precio = request.getParameter("precio"),
        desc = request.getParameter("desc"),
        tipo = request.getParameter("tipo"),
        disp = request.getParameter("disp"),
        categoria = request.getParameter("categoria")/*,
        tienda = request.getParameter("tienda")*/;
        
        //System.out.println("Tiendas seleccionadas: " + tienda);
        
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
                
                //si existe un c_i_prod, actualizar el producto correspondiente
                if(in_jvs_modificar != null && !in_jvs_modificar.isEmpty()){
                    int tmp_jvi_modificar = Integer.parseInt(in_jvs_modificar);
                    System.out.println("Se modificara el sig prod: " + tmp_jvi_modificar);
                    String upt_BD = "UPDATE o_producto "
                        + "SET n_v_nombre = '" + prod + "', d_v_cant = " + tmp_jvi_cant + ", d_v_precio = " + tmp_jvf_precio + ", d_v_desc = '" + desc + "', d_v_tipo = '" + tipo + "', d_v_disp = " + disp_INT + ", d_v_catego = '" + categoria + "' "
                        + "WHERE c_i_prod = " + tmp_jvi_modificar;
                    
                    try{
                        APConnection con_POOL = ds_CON.getConnection();
                        Statement stmt_CON = con_POOL.createStatement();
                        int res_STMT = stmt_CON.executeUpdate(upt_BD);
                        
                        if(res_STMT > 0){
                            System.out.println("exito update");
                        }
                        con_POOL.close();
                        stmt_CON.close();

                    } catch (SQLException e) {
                        System.err.println("Error en la conexión o consulta: " + e.getMessage());
                    }

                } else {
                    // Agregarlo a la BASE si no existe
                    String ins_BD = "insert into o_producto (c_i_usu,n_v_nombre,d_v_cant,d_v_precio,d_v_desc,d_v_tipo,d_v_disp,d_v_catego)" + 
                    "values ('" + usuID_BD + "','" + prod + "','" + tmp_jvi_cant + "','" + tmp_jvf_precio + "','" + desc + "','" + tipo + "','" + disp_INT + "','" + categoria + "');";

                    try{
                        APConnection con_POOL = ds_CON.getConnection();
                        Statement stmt_CON = con_POOL.createStatement();
                        int res_STMT = stmt_CON.executeUpdate(ins_BD);

                        if(res_STMT > 0){
                            System.out.println("exito registro");
                        }

                        con_POOL.close();
                        stmt_CON.close();
                    } catch (SQLException e) {
                        System.err.println("Error en la conexión o consulta: " + e.getMessage());
                    }
                }
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

    // codigo para BORRADO LOGICO
    if(in_jvs_borrar != null && !in_jvs_borrar.isEmpty()){
        int tmp_jvi_borrar = Integer.parseInt(in_jvs_borrar);
        String delMast_BD = "UPDATE o_producto SET d_v_edo = 0 WHERE c_i_prod = " + tmp_jvi_borrar,
        delDet_BD = "UPDATE d_producto SET d_v_edo = 0 WHERE c_i_prod = " + tmp_jvi_borrar;
        try{
            APConnection con_POOL = ds_CON.getConnection();
            Statement stmt_CON = con_POOL.createStatement();

            //borrar tabla maestro
            int res_STMT = stmt_CON.executeUpdate(delMast_BD);
            if(res_STMT > 0){
                System.out.println("exito al eliminar.");
            }
            
            //borrar detalles
            res_STMT = stmt_CON.executeUpdate(delDet_BD);
            if(res_STMT > 0){
                System.out.println("exito al eliminar.");
            }

            con_POOL.close();
            stmt_CON.close();
        } catch (SQLException e) {
            System.err.println("Error en la conexión o consulta: " + e.getMessage());
        }
    }
%>
  
    <h2 class='uk-text-bold'><span class='uk-text-stroke'>Pro</span>ductos</h2>
    <div class="uk-overflow-auto">
        <table class="uk-table uk-table-striped uk-table-small uk-table-justify uk-margin-medium-bottom">
            <thead>
                <tr>
                    <th class='uk-text-center uk-text-secondary'>Nombre</th>
                    <th class='uk-text-center uk-text-secondary'>Cantidad</th>
                    <th class='uk-text-center uk-text-secondary'>Precio</th>
                    <th class='uk-text-center uk-text-secondary'>Descripción</th>
                    <th class='uk-text-center uk-text-secondary'>Tipo</th>
                    <th class='uk-text-center uk-text-secondary'>Disponible</th>
                    <th class='uk-text-center uk-text-secondary'>Categoría</th>
                    <th class='uk-text-center uk-text-secondary'>Tiendas</th>
                    <th class='uk-text-center uk-text-success'>Editar</th>
                    <th class='uk-text-center uk-text-danger'>Borrar</th>
                </tr>
            </thead>
            <tbody>
<%  
    String qry_BD = "SELECT * FROM o_producto WHERE c_i_usu = " + usuID_BD + " AND d_v_edo = 1";
    try {
        APConnection con_POOL = ds_CON.getConnection();
        Statement stmt_CON = con_POOL.createStatement();
        ResultSet res_STMT = stmt_CON.executeQuery(qry_BD);

        boolean tieneProd_USU = false;
        while (res_STMT.next()) {
                tieneProd_USU = true;
                
                String ID_PROD = res_STMT.getString("c_i_prod"), /// integer porque ahorra tiempo de procesamiento
                nom_PROD = res_STMT.getString("n_v_nombre"),
                cant_PROD = res_STMT.getString("d_v_cant"),
                precio_PROD = res_STMT.getString("d_v_precio"),
                tipo_PROD = res_STMT.getString("d_v_tipo"),
                desc_PROD = res_STMT.getString("d_v_desc"),
                disp_PROD = res_STMT.getString("d_v_disp"),
                catego_PROD = res_STMT.getString("d_v_catego");

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
%>
                <tr>
                    <td class='uk-text-center'><%= nom_PROD %></td>
                    <td class='uk-text-center'><%= cant_NUM %></td>
                    <td class='uk-text-center'>$<%= precio_NUM %> MXN</td>
                    <td class='uk-table-expand'><%= desc_PROD %></td>
                    <td class='uk-text-center'><%= tipo_PROD %></td>
                    <td class='uk-text-center'>
<%
                if(disp_NUM == 1){
%>              
                    <input class="uk-checkbox tabla" type="checkbox" disabled checked>
<%
                } else {
%>
                    <input class="uk-checkbox tabla" type="checkbox" disabled>
<%
                }
%>
                    </td>
                    <td class='uk-text-center'><%= catego_PROD %></td>
                    <td class='uk-table-expand'>
<%              
                String qry_BD_02 = "SELECT t.n_v_nom FROM negocio.c_tienda t LEFT JOIN negocio.d_producto p "
                + "on(t.c_i_tienda = p.c_i_tienda) WHERE p.c_i_prod = " + ID_PROD;
                
                // obtener las tiendas del producto
                ResultSet res_STMT_02 = stmt_CON.executeQuery(qry_BD_02);
                
                boolean hayTienda = false;
                while (res_STMT_02.next()) {
                hayTienda = true;
%>
                    <span class="uk-badge"><%= res_STMT_02.getString(1) %></span>
<%
                }
                if(!hayTienda){
%>
                    Sin tienda.
<%
                }
%>
                    </td>
                    <td><a class="uk-text-success" uk-icon="icon: pencil" href="javascript:void(0);" onclick="js_FS010(<%= ID_NUM %>,'<%= nom_PROD %>',<%= cant_NUM %>,
                           <%= precio_NUM %>,'<%= desc_PROD.replace("\n", " ").replace("\r", " ").replace("'", "\\'").replace("\"", "\\\"") %>',
                                       '<%= tipo_PROD %>',<%= disp_NUM %>,'<%= catego_PROD %>');"></a></td>
                    <td><a class="uk-text-danger" uk-icon="icon: trash" href="javascript:void(0);" onclick="js_FS009(<%= ID_NUM %>);"></a></td>
                </tr>
<%      
    
            con_POOL.close();
            stmt_CON.close();
            res_STMT.close();
            res_STMT_02.close();
        }
        if(!tieneProd_USU){
%>
                <tr><td colspan="10"><p>Aún no se registra ningún producto.</p></td></tr>       
<%      }
    } catch (SQLException e) {
        System.err.println("Error en la conexión o consulta: " + e.getMessage());
    }
%>
            </tbody>
        </table>
    </div>
