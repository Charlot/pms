module ProcessTemplatesHelper
  def process_type_options
    ProcessType.to_select.map { |t| [t.display, t.value] }
  end

  def template_to_html(process_template)
    html=''
    process_template.template_texts.each_with_index do |s, i|
      html +=s
      if cf= process_template.custom_fields[i]
        html+=(render partial: 'custom_fields/format/input', locals: {field: cf, index: i}).to_s.html_safe
      end
    end
    html.html_safe
  end
end
