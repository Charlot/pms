/**
 * Created by tesla on 15-2-9.
 */
var pms = pms || {};

pms.kanban = pms.kanban || {};

pms.kanban.addRouting = function(kanban_id,process_entity_ids,callback){
    var route_ids = [];
    route_ids.push(process_entity_ids);
    $.ajax({
        url:"/kanbans/"+kanban_id+"/add_process_entities",
        data:{process_entities:route_ids},
        type:"POST",
        dataType:'json',
        success:function(data){
            if(callback){
                callback(data);
            }
        }
    });

    /*$.ajax({
        url:'/parts/'+part_id+'/add_process_entities',
        data:{process_entities:process_entity_ids},
        type:'POST',
        dataType:'json',
        success:function(data){
            if(callback){callback(data)}
        }
    });*/
};

pms.kanban.delRouting = function(kanban_id,process_entity_ids,callback){
    var route_ids = [];
    route_ids.push(process_entity_ids);

    $.ajax({
        url:"/kanbans/"+kanban_id+"/delete_process_entities",
        data:{process_entities:route_ids},
        type:"DELETE",
        dataType:'json',
        success:function(data){
            if(callback){
                callback(data);
            }
        }
    });

    /*$.ajax({
        url:"/parts/"+part_id+"/delete_process_entities",
        data:{process_entities:process_entity_ids},
        dataType:'json',
        type:'delete',
        success:function(data){
            if(callback){callback(data)}
        }
    })*/
};

pms.kanban.routeSimple = function(process_entity_id,callback) {
    $.ajax({
        url: '/process_entities/' + process_entity_id + "/simple",
        dataType: 'html',
        type: 'GET',
        success: function (data) {
            if(callback) {callback(data)}
        }
    })
};

pms.kanban.scan = function(code,callback){
    $.ajax({
        url: '/kanbans/scan',
        data: {code:code},
        dataType:'json',
        type:'POST',
        success: function(data){
            if(callback){
                callback(data);
            }
        }
    })
};

pms.kanban.search = function(params,callback){
    $.ajax({
        url: '/kanbans/search',
        data:{part_nr:params.part_nr,product_nr:params.product_nr},
        dataType:'html',
        type:'GET',
        success: function (data) {
            if(callback){callback(data)}
        }
    })
};