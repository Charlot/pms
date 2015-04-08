var pms = pms || {};

pms.search = function(model,options,callback){
    $.ajax({
        url: "/" + model + "/search",
        data: options,
        type: 'GET',
        dataType: 'json',
        success: function(data){
            if(callback){
                callback(data);
            }
        }
    });
};