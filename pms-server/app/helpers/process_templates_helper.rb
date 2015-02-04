module ProcessTemplatesHelper
  def process_type_options
    ProcessType.to_select.map { |t| [t.display, t.value] }
  end
end
