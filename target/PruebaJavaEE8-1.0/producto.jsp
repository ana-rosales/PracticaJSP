<%@page import="com.apro.db.APDataSource"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.apro.comercio.Tienda"%>
<%@page import="com.apro.db.ConectorBD"%>
<%@page contentType="text/html" pageEncoding="UTF-8" import="
        java.sql.SQLException,java.sql.ResultSet,java.sql.Connection"%>

<div class="uk-modal-dialog uk-margin-auto-vertical uk-background-secondary uk-light">
    <div class="uk-modal-header uk-background-secondary uk-light">
        <h2 id="crearProducto_TIT" class="uk-modal-title">Ingresar producto.</h2>
    </div>
    <div class="uk-modal-body">
        <fieldset class="uk-fieldset uk-column-1-3@m">
            <div class="uk-margin">
                <input class="uk-input" type="text" id="prod" name="prod" placeholder="Nombre del producto" aria-label="Input">
            </div>
            <div class="uk-margin">
                <input class="uk-input" type="number" id="cant" name="cant" placeholder="Cantidad" aria-label="Input">
            </div>
            <div class="uk-margin">
                <input class="uk-input" type="number" id="precio" name="precio" placeholder="Precio" aria-label="Input" max="99999.99">
            </div>
            <div class="uk-margin">
                <textarea class="uk-textarea" rows="10" cols="100" name="desc" id="desc" rows="10" placeholder="Descripción del producto" aria-label="Textarea"></textarea>
            </div>
            <div class="uk-margin uk-grid-small uk-child-width-auto uk-grid">
                <label><input class="uk-radio" type="radio" name="tipo" id="permanente" value="Permanente"> Producto permanente</label>
                <label><input class="uk-radio" type="radio" name="tipo" id="especial" value="Especial"> Edición especial</label>
            </div>
            <div class="uk-margin uk-grid-small uk-child-width-auto uk-grid">
                <label><input class="uk-checkbox" type="checkbox" id="disp" name="disp"> El producto está disponible.</label>
            </div>
            <div class="uk-margin">
                <select class="uk-select" aria-label="Select" name="categoria" id="categoria">
                    <option value="">Seleccione una categoría.</option>
                    <option value="Coleccion">Artículo de colección</option>
                    <option value="Oficina">Artículo de oficina</option>
                    <option value="Belleza">Belleza.</option>
                    <option value="Miscelaneo">Misceláneo.</option>
                </select>
            </div>
            <div class="uk-margin">
                <label>Seleccione una o varias tiendas.</label>
                <select class="uk-select" aria-label="Select" name="tienda" id="tienda" multiple>
<%
                    //Obtener el DataSource para consultar.
                    String usu_BD = "root", 
                    pwd_BD = "admin", 
                    base_BD = "negocio", 
                    driver_BD = "org.mariadb.jdbc.Driver",
                    url_BD = "jdbc:mariadb://localhost:3360/";    
                    APDataSource ds_CON = ConectorBD.getDataSource(usu_BD, pwd_BD, base_BD, driver_BD, url_BD);
                    
                    try{
                        ArrayList<Tienda> al_TND = ConectorBD.getTiendas(ds_CON);
                        if(al_TND != null){
                            for(Tienda tnd_BD: al_TND){
%>
                            <option value="<%= tnd_BD.getId_TND() %>"><%= tnd_BD.getNom_TND() %></option>
<%
                            }
                        } else {
%>
                        <option>Sin tiendas en la Base de Datos.</option>
<%
                        }
                    }catch (SQLException e) {
                        System.err.println("Error en la conexión o consulta: " + e.getMessage());
                    }
%>                    
                </select>
            </div>
        </fieldset>
        <div class="uk-divider"></div>
        <div class="uk-fieldset uk-flex uk-container uk-container-xsmall uk-flex-column uk-flex-between@m uk-flex-row@m">
            <a class="uk-button uk-button-primary" id='crearProducto_BTN' href="javascript:void(0);" onclick="js_inProd(js_resModif);">Ingresar producto</a>
            <a class="uk-button uk-button-default" href="javascript:void(0);" onclick="js_FS000();">Limpiar campos</a>
            <a class="uk-button uk-button-danger" href="javascript:void(0);" onclick="js_FS004();">Anular ingreso</a>
        </div>
    </div>
    <button class="uk-modal-close-default" type="button" uk-close></button>
</div>
