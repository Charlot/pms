var pms = pms || {};

pms.search = function(model,q,callback,options){
    options = null != options ? options : {}
    var opt = {};
    opt.dataType = 'json';
    $.extend(opt,options);

    $.ajax({
        url: "/" + model + "/search",
        data: {"q":q},
        type: 'GET',
        dataType: opt.dataType,
        success: function(data){
            if(callback){
                callback(data);
            }
        }
    });
};