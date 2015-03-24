module PartsHelper
  def part_type_select_options
    PartType.to_select.collect{|s| [s.display,s.value]}
  end
end
