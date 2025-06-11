<%@page contentType="text/html" pageEncoding="UTF-8" import="
        com.apro.db.ConectorBD,java.sql.SQLException,java.sql.ResultSet,
        com.apro.db.APDataSource, java.sql.Connection,
        java.sql.Statement,com.apro.comercio.Usuario"%>
<%! 
    public int validaUsu(String usu_PARAM, String contra_PARAM, APDataSource ds_PARAM){

        int ok = -1;
        String qry_STMT = "select * from c_usuario where n_v_nombre = '" + usu_PARAM + "' and d_v_contra = '" + contra_PARAM + "';";

        /**
         * Obtener una conexion del pool del DataSource.
         */
        try{
            Connection con_POOL = ds_PARAM.getConnection();
            Statement stmt_CON = con_POOL.createStatement();
            ResultSet res_QRY = stmt_CON.executeQuery(qry_STMT);

            while (res_QRY.next()) {
                String usu_RES = res_QRY.getString("n_v_nombre");
                String contra_RES = res_QRY.getString("d_v_contra");

                if(usu_PARAM.equals(usu_RES) && contra_PARAM.equals(contra_RES)){
                    ok = Integer.parseInt(res_QRY.getString("c_i_usu"));
                }
            }
            stmt_CON.close();
            res_QRY.close();
        } catch (SQLException e) {
            System.err.println("Error en la conexión o consulta: " + e.getMessage());
        }
        return ok;
    }
%>
<%
    //Obtener el DataSource para consultar.
    APDataSource ds_CON = ConectorBD.getDataSource("usuarios.properties");
    
    //Obtener los datos encapsulados en el POST.
    String usu_REQ = request.getParameter("nom"),
    contra_REQ = request.getParameter("pwd");
    
    //Objeto donde se almacenara el usuario.
    Usuario usu_OBJ = new Usuario();
    usu_OBJ.setNom_USU(usu_REQ);
    usu_OBJ.setContra_USU(contra_REQ);
    usu_OBJ.setLogged(false);
    
    //Variable para almacenar el resultado de validacion.
    int valUsu_RES;    
    
        //Validar no vacíos
        if(usu_REQ.equals("") || contra_REQ.equals("") || usu_REQ.trim().isEmpty() || contra_REQ.trim().isEmpty()){
            valUsu_RES = 1;        
        } else {
            //validar existencia de usuario
            int valUsu = validaUsu(usu_REQ,contra_REQ,ds_CON);
            
            if(valUsu >= 0){
                //aqui es posible iniciar sesion.
                usu_OBJ.setId_USU(valUsu);
                session.invalidate();
                session = request.getSession(true);
                session.setAttribute("usu_SESS",usu_OBJ);
                valUsu_RES = 0; 
            } else {
                valUsu_RES = 2;
            }
        }
        
        /**
         * Liberar recursos de datasource.
         */
        ds_CON = null;
        
%>
<input type="hidden" id="valUsu" value=<%= valUsu_RES %>>

