module CustomFieldsHelper
  def format_type_options
    CustomFieldFormatType.to_select.map { |t| [t.display, t.value] }
  end

  def format_type_js_var
    hash={}
    CustomFieldFormatType.to_select.select { |t| hash[t.key]=t.value }
    hash
  end
end
