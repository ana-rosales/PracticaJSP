<%@page contentType="text/html" pageEncoding="UTF-8" import="com.apro.comercio.ListaProductos,com.apro.comercio.Producto,com.apro.db.ConectorDB,java.sql.SQLException,java.sql.ResultSet,java.sql.Connection"%>
<%! 
    //SCRIPLET -> funje como clase para evitar crear una.
    //Se utiliza si los métodos y atributos de esta clase solo se utilizan aquí.
    
    //Método para validar al usuario.
    public int validaUsu(String usu_PARAM, String contra_PARAM){
        int ok_NUM = -1;

        try (Connection conexion = ConectorDB.crearConexion_BD()) {
            
            ResultSet resultado = ConectorDB.consultar_BD("SELECT * FROM c_usuario",conexion);
            
            while (resultado.next()) {
                String usu_RES = resultado.getString("n_v_nombre");
                String contra_RES = resultado.getString("d_v_contra");

                if(usu_PARAM.equals(usu_RES) && contra_PARAM.equals(contra_RES)){

                    try{
                        ok_NUM = Integer.parseInt(resultado.getString("c_i_usu"));
                    } catch (NumberFormatException nfe){
                        ok_NUM = -1;     
                    }

                }
                System.out.println(resultado.getString(1) + " - " + resultado.getString(2));
            }
        } catch (SQLException e) {
            System.err.println("Error en la conexión o consulta: " + e.getMessage());
        }
        return ok_NUM;
    }
//FIN SCRIPLET
%>
<%
    ConectorDB.cargarDriver_BD("org.mariadb.jdbc.Driver");
    
    //Obtener los datos encapsulados en el POST
    String usu_REQ = request.getParameter("nom"),
    contra_REQ = request.getParameter("pwd"),
    haySesion_REQ = request.getParameter("sesion");
    
    if (haySesion_REQ == null) haySesion_REQ = "0"; 

        //Validar no vacíos
        if(usu_REQ.equals("") || contra_REQ.equals("") || usu_REQ.trim().isEmpty() || contra_REQ.trim().isEmpty()){
%>
            <script>   
                $(function(){ 
                    UIkit.modal('#vacio').show();
                    if(<%= haySesion_REQ %> === "0"){
                        $('#fondo').show();
                    }
                });	
            </script> 
<%
        } else {
            //validar usuario
            int usuID_BD = validaUsu(usu_REQ,contra_REQ);
            
            //AQUI EL USUARIO ES VALIDO
            if(usuID_BD >= 0){
                // se intenta iniciar cuando aun no hay sesion
                if("0".equals(haySesion_REQ)){
                    
                    // volver a iniciar sesion con el nuevo usuario
                    session.invalidate();
                    session = request.getSession(true);
                    session.setAttribute("usu_SESS", usuID_BD);
                    
                    haySesion_REQ = "1";
%>
                    <script>
                        $(function(){ 
                            $("#fondo").hide();
                        });
                    </script>
                    <div class="uk-divider"></div>
                    <%-- info usuario --%>
                    <div class="uk-container uk-container-expand uk-flex uk-flex-column uk-flex-between@s uk-flex-row@s">
                        <h1 class="uk-text-center uk-text-bold uk-margin-auto-vertical uk-margin-remove@s">
                            Bienvenido <span class='uk-text-stroke'><%= usu_REQ %></span>
                        </h1>
                        <div class="uk-flex uk-flex-column-reverse uk-flex-column@s">
                            <a id='cerrarSesion_BTN' class="uk-button uk-button-danger uk-margin-bottom" href="javascript:void(0);" onclick="js_FS003();">Cerrar sesión</a>
                            <a id='formCrear_BTN' class="uk-button uk-button-primary" href="javascript:void(0);" onclick="js_FS002();">Ingresar producto</a>
                        </div>
                    </div>
                    <hr />
<%              // se intenta iniciar cuando ya hay sesion
                } else {
                    haySesion_REQ = "0";
%>
                    <script>   
                        $(function(){ 
                            UIkit.modal('#confirmar-inicio').show();
                        });	
                    </script>
<%
                }
            } else {
%>
                <script>   
                    $(function(){ 
                        UIkit.modal('#usuario-invalido').show();
                        if(<%= haySesion_REQ %> === "0"){
                            $('#fondo').show();
                        }
                    });	
                </script> 
<%
            }
        }
%>
<input type="hidden" id="sesion" value="<%= haySesion_REQ %>">