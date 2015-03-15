class ImportTemplate
  BOM_CSV_TEMPLATE='bom新建模板.csv'
  PART_CSV_TEMPLATE='part新建模板.csv'

  def self.method_missing(method_name, *args, &block)
    if method_name.to_s.include?('_template')
      return Base64.urlsafe_encode64(File.join($template_file_path, self.const_get(method_name.upcase)))
    else
      super
    end
  end
end