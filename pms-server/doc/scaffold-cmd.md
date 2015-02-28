rails g scaffold measure_unit code:string:index describe:string cn:string en:string
rails g scaffold resource_group nr:string:index resource_group_type:integer:index name:string description:string
rails g scaffold part nr:string:index custom_nr:string:index type:integer:index strip_length:float resource_group:references measure_unit:references
rails g scaffold part_bom part:references bom_item_id:integer:index quantity:float
rails g scaffold custom_fields type:string:index name:string field_format:string possible_values:text regexp:string min_length:integer max_length:integer is_required:boolean is_for_all:boolean is_filter:boolean position:integer searchable:boolean default_value:text editable:boolean visible:boolean multiple:boolean format_store:text is_query_value:boolean validate_query:text value_query:text  description:text
rails g scaffold custom_values customized_type:string customized_id:integer custom_field:references value:text
rails g scaffold process_template code:string:index type:integer:index name:string template:text description:text
rails g scaffold process_entity nr:string name:strint description:text stand_time:float process_template:references workstation_type:references cost_center:references
rails g scaffold machine nr:string:index name:string description:string resource_group:references
rails g scaffold machine_scope w1:boolean t1:boolean t2:boolean s1:boolean s2:boolean wd1:boolean w2:boolean t3:boolean t4:boolean s3:boolean s4:boolean wd2:boolean machine:references
rails g scaffold machine_scope w1:boolean t1:boolean t2:boolean s1:boolean s2:boolean wd1:boolean w2:boolean t3:boolean t4:boolean s3:boolean s4:boolean wd2:boolean machine:references
rails g scaffold machine_combination w1:integer t1:integer t2:integer s1:integer s2:integer wd1:integer w2:integer t3:integer t4:integer s3:integer s4:integer wd2:integer machine:references

