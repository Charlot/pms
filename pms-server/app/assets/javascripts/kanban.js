/**
 * Created by tesla on 15-2-9.
 */
var pms = pms || {};

pms.kanban = pms.kanban || {};

pms.kanban.addRouting = function(kanban_id,process_entity_nr,callback){
    $.ajax({
        url: '/kanbans/'+kanban_id+"/create_process_entities",
        data :{process_entity_nr:process_entity_nr},
        dataType:'json',
        type:'POST',
        success: function(data){
            if(callback){
                callback(data);
            }
        }
    })
};

pms.kanban.delRouting = function(kanban_id,id,callback){
    $.ajax({
        url: '/kanbans/'+kanban_id+"/destroy_process_entities",
        data :{kanban_process_entity_id:id},
        dataType:'json',
        type:'DELETE',
        success: function(data){
            if(callback){
                callback(data);
            }
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
}