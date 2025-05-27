/**
 * Validacion del lado del cliente sesion iniciada.
 */
var open_SESS;

/**
 * Cierra sesion del lado del servidor y
 * da un valor false a open_SESS.
 * Callback para procesar en caso de error.
 */
function js_cerrarSess(callback){
    $.post("cerrarSESS.jsp",{},(data)=>{
        $("#r_RESVAL").empty().html(data);
    });
    if(typeof callback === "function"){
        setTimeout(callback, 1000); //espera 4 segundos
    }
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
 * Da valor a open_SESS con un callback.
 */
function js_haySess(callback){
    $.post("haySESS.jsp",{},(data)=>{
        $("#r_RESVAL").empty().html(data);
    });
    if(typeof callback === "function"){
        setTimeout(callback, 1000); //espera 4 segundos
    }
}

/**
 * Callback procesa el resultado de js_haySess() al recargar pagina.
 */
function js_resHayReload(){
    var res_HAY = parseInt($("#haySess").val());
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
    if(res_HAY == 1){
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
    });
    
    if(typeof callback === "function"){
        setTimeout(callback, 1000); //espera un segundo al $.post
    }
}

/**
 * Funcion callback para procesar el resultado de la validacion
 * de usuario.
 * 
 * @return el resultado del procesamiento.
 */
function js_resVal(){
    var res_VAL = parseInt($("#valUsu").val());
    if(res_VAL == 0){
        location.reload();
    } else if (res_VAL == 1){
        UIkit.modal('#vacio').show();
    } else if (res_VAL == 2){
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
 * Funcion para pintar el form de ingresar 
 * o actualizar producto.
 * Funcion callback para inicializar los inputs
 * con los valores a actualizar en caso de UPDATE.
 */
function js_formProd(callback){
    $.post("producto.jsp",{},(data)=>{
        $("#r_formPROD").empty().html(data);
        UIkit.modal('#r_formPROD').show();
    });
    if (typeof callback === "function") {
        setTimeout(callback, 50); //espera 50 milisegundos.
    }
}

/**
 * Inicializacion del documento.
 */
$(document).ready(()=>{
    //se verifica si hay una sesion antes.
    js_haySess(js_resHayReload);
    //luego se hace lo demas.
    setTimeout(()=>{
        
        if(open_SESS){
            js_traerUsu();
            js_traerProd();
            $("#fondo").hide();
        }
    
    },1000); //espera un segundo a verificacion.
});

/*$(document).ready(()=>{
   setTimeout(()=>{
   },4000);
});*/