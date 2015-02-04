rails g scaffold measure_unit code:string:index describe:string cn:string en:string
rails g scaffold part nr:string:index custom_nr:string:index part_type:integer:index measure_unit:references
rails g scaffold part_bom part:references bom_item_id:integer:index quantity:float
rails g scaffold process_custom_fields type:string:index name:string field_format:string possible_values:text regexp:string min_length:integer max_length:integer is_required:boolean is_for_all:boolean is_filter:boolean position:integer searchable:boolean default_value:text editable:boolean visible:boolean multiple:boolean format_store:text is_query_value:boolean validate_query:text value_query:text  description:text
rails g scaffold process_custom_values customized_type:string customized_id:integer custom_field_id:integer:index value:text
rails g scaffold process_template code:string:index type:integer:index name:string template:text description:text