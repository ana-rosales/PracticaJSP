<%@page contentType="text/html" pageEncoding="UTF-8" import="
        java.sql.Connection,com.apro.db.APDataSource, java.util.List,
        com.apro.db.ConectorBD,java.sql.SQLException,java.util.Random,
        java.util.ArrayList,java.sql.Statement,java.sql.ResultSet,
        java.util.Arrays"%>
<%
    //establecer conexiones.
    List<String> prop_LIST = Arrays.asList(
            "negocio.properties","usuarios.properties");
    List<String> stmts_LIST = Arrays.asList(
            "select * from o_producto where d_v_catego = 'Miscelaneo';",
            "select * from c_usuario;");
    
    Random r_NUM = new Random();
    long time_INI = System.currentTimeMillis(); //tiempo inicio
    
    long time_TRANS;
    double time_MIN, time_SECS,time_MILIS;
    
    //hacer una consulta 
    for(int i = 1;i<100000;i++){
        System.out.println(i + ".-");
        int r_GEN = r_NUM.nextInt(2);
        
        APDataSource ds_BD = ConectorBD.getDataSource(prop_LIST.get(r_GEN));
        System.out.println("Base: " + prop_LIST.get(r_GEN));
        
        Connection con_BD = ds_BD.getConnection();
        try{
            Statement stmt_CON = con_BD.createStatement();
            ResultSet rs_STMT = stmt_CON.executeQuery(stmts_LIST.get(r_GEN));
            
            //consulta a sqlite
            if(r_GEN == 1){
                String usus = "";
                boolean hayUsu = false;
                while(rs_STMT.next()){
                    hayUsu = true;
                }
                if(hayUsu){
                    System.out.println("Consulta usuarios exitosa.");
                }
            } else {
            
                //consulta a mariadb
                String prods = "";
                boolean hayProd = false;
                while(rs_STMT.next()){
                    hayProd = true;
                }
                if(hayProd){
                    System.out.println("Consulta productos exitosa.");
                }
            }
        } catch(SQLException e){
            System.out.println("Error en la consulta o conexion: " + e);
        }
        time_TRANS = System.currentTimeMillis() - time_INI; //tiempo transcurrido
        time_SECS = time_TRANS /1000;
        time_SECS = Math.floor(time_SECS);
        time_MILIS = time_TRANS - time_SECS * 1000;

        time_MIN = time_SECS / 60;
        time_MIN = Math.floor(time_MIN);
        time_SECS = time_SECS - time_MIN * 60;
        
        System.out.println();
        System.out.println("Tiempo transcurrido: " + time_MIN + " : " + time_SECS + " : " + time_MILIS + " --");
        System.out.println();
    }
    
    long time_FIN = System.currentTimeMillis() - time_INI; //tiempo final
    
    time_SECS = time_FIN /1000;
    time_SECS = Math.floor(time_SECS);
    time_MILIS = time_FIN - time_SECS * 1000;
    
    time_MIN = time_SECS / 60;
    time_MIN = Math.floor(time_MIN);
    time_SECS = time_SECS - time_MIN * 60;
    
    
    System.out.println();
    System.out.println("-- FIN " + time_MIN + " : " + time_SECS + " : " + time_MILIS + " --");
    System.out.println();
%>