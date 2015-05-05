class ImportTemplate
  BOM_CSV_TEMPLATE='bom.csv'
  PART_CSV_TEMPLATE='part.csv'
  PROCESS_TEMPLATE_CSV_TEMPLATE='process_template.csv'
  PROCESS_ENTITY_AUTO_CSV_TEMPLATE='process_entity_auto.csv'
  PROCESS_ENTITY_AUTO_EXCEL_TEMPLATE='process_entity_auto.xlsx'
  PROCESS_ENTITY_SEMI_AUTO_CSV_TEMPLATE='process_entity_semi_auto.csv'
  PROCESS_ENTITY_SEMI_AUTO_EXCEL_TEMPLATE='process_entity_semi_auto.xlsx'
  KANBAN_CSV_TEMPLATE='kanban.csv'
  KANBAN_EXCEL_TEMPLATE='kanban.xlsx'
  KANBAN_SCAN_EXCEL_TEMPLATE='kanban_scan.xlsx'
  KANBAN_GET_LIST_CSV_TEMPLATE='get_kanban_list.csv'
  MACHINE_CSV_TEMPLATE='machine.csv'
  MACHINE_COMBINATION_CSV_TEMPLATE='machine_combination.csv'
  MACHINE_TIME_RULE_EXCEL_TEMPLATE='machine_time_rule.xlsx'
  TOOL_CSV_TEMPLATE='tool.csv'
  PART_POSITION_CSV_TEMPLATE='part_position.csv'
  MASTER_BOM_CSV_TEMPLATE='master_bom.csv'
  ORDER_BOM_CSV_TEMPLATE='order_transport.csv'

  def self.method_missing(method_name, *args, &block)
    if method_name.to_s.include?('_template')
      return Base64.urlsafe_encode64(File.join($template_file_path, self.const_get(method_name.upcase)))
    else
      super
    end
  end
end