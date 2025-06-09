<%@page import="com.apro.comercio.Producto"%>
<%@page contentType="text/html" pageEncoding="UTF-8" import="
        java.util.Random,java.util.Arrays,java.util.List,java.util.ArrayList,
        com.apro.db.ConectorBD,java.sql.Connection,com.apro.db.APDataSource,
        java.sql.PreparedStatement,java.sql.ResultSet,java.sql.SQLException"%>
<%
    APDataSource ds = ConectorBD.getDataSource("negocio.properties");
    // generar random contenido
    Random r = new Random();
    //int numero_inicial = 11;
    List<String> tipo = Arrays.asList("Permanente","Especial");
    List<String> catego = Arrays.asList("Coleccion","Oficina","Belleza","Miscelaneo"); 
    ArrayList<Integer> tnd_CAT = new ArrayList<>();
    tnd_CAT.add(1);
    tnd_CAT.add(2);
    tnd_CAT.add(3);
    tnd_CAT.add(4);
    tnd_CAT.add(5);
    tnd_CAT.add(6);
    tnd_CAT.add(7);
    Double randPrecio_DOUB; 
    String[] splitter;
    String pEntera,pDecimal;
    String randPrecio_STR;
    Float randPrecio_FLT;
    int resIns;
    Producto prod = new Producto();

    for(int i = 100001; i <= 100000;i++){
        List<Integer> tnd_TRASH = tnd_CAT.subList(0, tnd_CAT.size());
        List<Integer> tnd_ARR = new ArrayList<>();
        randPrecio_DOUB = 1 + r.nextDouble() * (99999.99 + 1);
        splitter = randPrecio_DOUB.toString().split("\\.");
        pEntera = splitter[0];
        pDecimal = splitter[1].substring(0, 2);
        randPrecio_STR = pEntera + "." + pDecimal;
        randPrecio_FLT = Float.parseFloat(randPrecio_STR);
        
        prod.setNom("prod " + i);
        prod.setCant(r.nextInt(9999));
        prod.setPrecio(randPrecio_FLT);
        prod.setDesc("Aqui iria la descripcion del producto numero " + i + ".");
        prod.setTipo(tipo.get(r.nextInt(2)));
        prod.setDisp(r.nextInt(2));
        prod.setCategoria(catego.get(r.nextInt(4)));
        
        //creando tnd_ARR
        for(int j = 0;j<r.nextInt(tnd_CAT.size());j++){
            tnd_ARR.add(
                tnd_TRASH.remove(
                    r.nextInt(tnd_TRASH.size())
                )
            );
        }
        
        try{
            resIns = ConectorBD.insProdMast(r.nextInt(11), prod, ds);
            
            //crear el detalle para las c_i_tienda en tnd_ARR
            if(!tnd_ARR.isEmpty()){
                for(Integer tnd_ID: tnd_ARR){
                    int set_DET = ConectorBD.setDetalle(resIns, tnd_ID, ds);
                    if(set_DET > 0){
                        System.out.println("exito registro");
                    }
                }
            }
        } catch (SQLException e){
            System.out.println("Error conexion: " + e);
        }
    }

%>