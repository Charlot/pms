rails g scaffold measure_unit code:string:index describe:string cn:string en:string --force
rails g scaffold part nr:string:index custom_nr:string:index part_type:integer:index measure_unit:references --force
rails g scaffold part_bom part:references bom_item_id:integer:index quantity:float --force
