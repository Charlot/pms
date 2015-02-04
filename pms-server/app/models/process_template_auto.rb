class ProcessTemplateAuto < ProcessTemplate
  def self.build_custom_field(field)
    case field
      when 'default_wire_nrd'
      else
        raise 'No such field for auto process template'
    end
  end
end
