/**
 * Validacion del lado del cliente sesion iniciada.
 */
var open_SESS;

/**
 * Cierra sesion del lado del servidor y
 * da un valor false a open_SESS.
 * Promesa para acciones luego de cerrar sesion.
 */
function js_cerrarSess(callback){
    $.post("cerrarSESS.jsp",{},(data)=>{
        $("#r_RESVAL").empty().html(data);
    }).then(callback);
}

/**
 * Callback para procesar resultado de 
 * cerrar sesion.
 */
function js_resCerrar(){
    var res_CERRAR = parseInt($("#cerrarSess").val());
    if(res_CERRAR == 1){
        alert("Error al cerrar sesion;");
    } else {
        open_SESS = false;
        location.reload();
    }
}


/**
 * Preguntar al servidor si hay una sesion.
 * Imprime un input con el resultado
 * Da valor a open_SESS desde un callback.
 */
function js_haySess(callback,callback2){
    $.post("haySESS.jsp",{},(data)=>{
        $("#r_RESVAL").empty().html(data);
    }).then(callback).then(callback2);
}

/**
 * Callback procesa el resultado de js_haySess() al recargar pagina.
 */
function js_resHayReload(){
    var res_HAY = parseInt($("#haySess").val());
    console.log("se recarga pagina y se obtiene si hay sesion: " + res_HAY);
    if(res_HAY == 1){
        open_SESS = true;
    } else {
        open_SESS = false;
    }
}

/**
 * Callback procesa el resultado de js_haySess() cuando se da clic
 * en boton de ingresar.
 * Si hay sesion previa, se solicita confirmacion para abrir una nueva.
 * Si no hay sesion previa, simplemente se intenta abrir una nueva.
 */
function js_resHayLogin(){
    var res_HAY = parseInt($("#haySess").val());
    console.log("se da clic en ingresar y se obtiene si hay sesion.");
    if(res_HAY === 1){
        UIkit.modal('#nuevo-inicio').show();
    } else {
        js_valUsu(js_resVal);
    }
}

/**
 * Validar usuario del lado del servidor.
 * Imprime un input con el resultado de la validacion: 
 * 0 si es valido, 1 si hay campos vacios, 2 si es invalido.
 * Se le pasa una funcion callback para procesar el resultado.
 */
function js_valUsu(callback){
    var v_01 = $("#nom").val();
    var v_02 = $("#pwd").val();
    console.log("Valida usuario.");
    $.post("valUSU.jsp",{nom: v_01,pwd: v_02},(data)=>{
        $("#r_RESVAL").empty().html(data);
    }).then(callback);
}

/**
 * Funcion callback para procesar el resultado de la validacion
 * de usuario.
 * 
 * @return el resultado del procesamiento.
 */
function js_resVal(){
    var res_VAL = parseInt($("#valUsu").val());
    if(res_VAL === 0){
        location.reload();
    } else if (res_VAL === 1){
        UIkit.modal('#vacio').show();
    } else if (res_VAL === 2){
        UIkit.modal('#usuario-incorrecto').show();
    }
}

/**
 * Cargar datos de usuario.
 * Trae los datos del servidor y los imprime
 * en el div correspondiente.
 */
function js_traerUsu(){    
    $("#r_infoUSU").empty().html('<span class="uk-margin-small-right" uk-spinner="ratio: 3"></span>');
    $.post("panelVendedor.jsp",{},(data)=>{
        $("#r_infoUSU").empty().html(data);
    });
}

/**
 * Cargar los datos de los productos del usuario con
 * sesion iniciada. Como parametro se le indica si 
 * se va a insertar, modificar o eliminar un producto.
 */
function js_traerProd(){    
    $("#r_infoPROD").empty().html('<span class="uk-margin-small-right" uk-spinner="ratio: 3"></span>');
    $.post("panelProductos.jsp",{},(data)=>{
        UIkit.modal('#r_formPROD').hide();
        $("#r_infoPROD").empty().html(data);
    });
}

/**
 * Funcion para ingresar un producto.
 * Despues de modificar se recarga la pagina.
 */
function js_inProd(callback){
    var v_01 = $('[name="prod"]').val();
    var v_02 = $('[name="cant"]').val();
    var v_03 = $('[name="precio"]').val();
    var v_04 = $('[name="desc"]').val();
    var v_05 = $('input[type="radio"]:checked').val();
    var v_06;
    var v_07 = $('[name="categoria"]').val();
    var v_08 = JSON.stringify($('[name="tienda"]').val());
    
    if($('[name="disp"]').is(':checked')){
        v_06 = '1';
    }else{
        v_06 = '0';
    }
    
    $.post("modifPROD.jsp",{
        prod: v_01, cant: v_02, precio: v_03, desc: v_04, 
        tipo: v_05, disp: v_06, categoria: v_07, tienda: v_08
    },(data)=>{
        $("#r_RESVAL").empty().html(data);
    }).then(callback);
}

/*
 * Callback procesa resultado de modificacion.
 */
function js_resModif(){
    var res_MODIF = parseInt($("#resModif").val());
    console.log(res_MODIF);
    if(res_MODIF === 0){
        location.reload();
    } else if(res_MODIF === 1) {
        UIkit.modal('#vacio').show();
    } else if(res_MODIF === 2) {
        UIkit.modal('#numerico-incorrecto').show();
    } else {
        alert("Error al modificar.");
    }
}

/**
 * Funcion para pintar el form de ingresar 
 * o actualizar producto.
 * Funcion callback para inicializar los inputs
 * con los valores a actualizar en caso de UPDATE.
 */
function js_formProd(callback,callback2){
    console.log("invocar form");
    $.post("producto.jsp",{},(data)=>{
        $("#r_formPROD").empty().html(data);
        UIkit.modal('#r_formPROD').show();
    }).then(callback).then(callback2);
}

/**
 * Callback busca un producto cuyos datos se actualizaran.
 */
function js_updateProd(id_PARAM){
    var v_01 = id_PARAM;
    
    $.post("obtPROD.jsp",{idProd: v_01},(data)=>{
        $("#r_RESVAL").empty().html(data);
    });
}

/**
 * Callback escribe los datos del producto en el form.
 */
function js_inpDat(){
    //datos respuesta
        var nom_PROD = $("#nomProd").val();
        var cant_PROD = $("#cantProd").val();
        var precio_PROD = $("#precioProd").val();
        var desc_PROD = $("#descProd").val();
        var tipo_PROD = $("#tipoProd").val();
        var disp_PROD = $("#dispProd").val();
        var catego_PROD = $("#categoProd").val();
        
        //datos form
        $('#prod').val(nom_PROD);
        $('#cant').val(cant_PROD);
        $('#precio').val(precio_PROD);
        $('#desc').val(desc_PROD);
        $('input[name="tipo"][value="'+tipo_PROD+'"]').prop('checked', true);
        $('#disp').prop('checked', disp_PROD == 1);
        $('#categoria').val(catego_PROD);
        $('#crearProducto_TIT').empty().html("Modificar producto.");
        $('#crearProducto_BTN').empty().html("Modificar producto.");
}

/**
 * Pasa al servidor el id del producto 
 * que se borrara logicamente.
 * Despues del borrado, se recarga la pagina.
 */
function js_delProd(id_PARAM,callback){
    var v_01 = id_PARAM;
    $.post("delPROD.jsp",{idProd: v_01},(data)=>{
        $("#r_RESVAL").empty().html(data);
    }).then(callback);
}

/**
 * Callback procesa resultado de eliminado logico.
 */
function js_resDel(){
    var res_DEL = parseInt($("#resDel").val());
    if(res_DEL === 0){
        location.reload();
    } else {
        alert("Error al eliminar.");
    }
}

/**
 * Esconde el form prod si no se hara ninguna accion.
 */
function js_FS004(){
    UIkit.modal('#r_formPROD').hide();
}

/**
 * Borra todos los inputs, a excepcion de los que se usan para
 * intercambiar información entre JSPs y los de la tabla productos.
 * 
 * @returns void.
 */
function js_FS000(){
    $('input').each(function() {
        if($(this).attr('id') == 'in_hi_borrar'){
           $(this).val('');
        }
        if($(this).attr('id') == 'in_hi_modif'){
           $(this).val('');
        }
        if(!$(this).is('input[type="hidden"]')){
            $(this).val('');
        }
        if($(this).is('input[type="checkbox"], input[type="radio"]')){
            if(!$(this).hasClass("tabla")){
                $(this).prop('checked', false);
            }
        }
    });
    $('textarea').each(function() {
        $(this).val('');
    });
    $('select').each(function() {
        $(this).val('');
    });
}

/**
 * Inicializacion del documento.
 */
$(document).ready(()=>{
    //se verifica si hay una sesion antes de cargar datos.
    
    js_haySess(js_resHayReload,()=>{
        console.log("hay sesion: " + open_SESS);
        if(open_SESS){
            js_traerUsu();
            js_traerProd();
            $("#fondo").hide();
        }
    });
});