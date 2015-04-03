class ImportTemplate
  BOM_CSV_TEMPLATE='bom.csv'
  PART_CSV_TEMPLATE='part.csv'
  PROCESS_TEMPLATE_CSV_TEMPLATE='process_template.csv'
  PROCESS_ENTITY_AUTO_CSV_TEMPLATE='process_entity_auto.csv'
  PROCESS_ENTITY_SEMI_AUTO_CSV_TEMPLATE='process_entity_semi_auto.csv'
  KANBAN_CSV_TEMPLATE='kanban.csv'
  MACHINE_CSV_TEMPLATE='machine.csv'
  MACHINE_COMBINATION_CSV_TEMPLATE='machine_combination.csv'
  TOOL_CSV_TEMPLATE='tool.csv'
  PART_POSITION_CSV_TEMPLATE='part_position.csv'

  def self.method_missing(method_name, *args, &block)
    if method_name.to_s.include?('_template')
      return Base64.urlsafe_encode64(File.join($template_file_path, self.const_get(method_name.upcase)))
    else
      super
    end
  end
end