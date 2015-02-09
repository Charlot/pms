class ProcessTemplateAuto < ProcessTemplate
  # DEFAULT_CUSTOM_FIELDS=%w(default_wire_nr wire_nr wire_qty_factor)
  def t1_strip_length
    self.custom_t1_strip_length || self.custom_t1_default_strip_length
  end


  def t2_strip_length
    self.custom_t2_strip_length || self.custom_t2_default_strip_length
  end

  def self.build_custom_fields(fields, target)
    cfs=[]
    fields.each do |field|
      cfs= cfs+build_custom_field(field, target)
    end
    cfs
  end

  def self.build_custom_field(field, target)
    cf=[]
    case field
      when 'default_wire_nr'
        cf<<CustomField.new(name: field,
                            type: target.custom_field_type,
                            is_query_value: true,
                            field_format: 'part',
                            value_query: 'Part.find_by_id(#).nr',
                            validate_query: 'Part.find_by_nr(#)',
                            description: 'auto template default custom field, default for white kb part, default_wire_nr')
      when 'wire_nr', 's1', 's2'
        cf<<CustomField.new(name: field,
                            type: target.custom_field_type,
                            is_query_value: true,
                            field_format: 'part',
                            value_query: 'Part.find_by_id(#).nr',
                            validate_query: 'Part.find_by_nr(#)',
                            is_for_out_stock: true,
                            description: "auto template default custom field, #{field}")
      when 'wire_qty_factor', 't1_qty_factor', 't2_qty_factor', 't1_strip_length', 't2_strip_length', 's1_qty_factor', 's2_qty_factor'
        cf<<CustomField.new(name: field,
                            type: target.custom_field_type,
                            field_format: 'float',
                            default_value: '0',
                            description: "auto template default custom field, #{field}")
      when 'default_bundle_qty'
        cf<<CustomField.new(name: field,
                            type: target.custom_field_type,
                            field_format: 'int',
                            default_value: '0',
                            description: 'auto template default custom field, default_bundle_qty')
      when 't1', 't2'
        cf<<CustomField.new(name: field,
                            type: target.custom_field_type,
                            is_query_value: true,
                            field_format: 'part',
                            value_query: 'Part.find_by_id(#).nr',
                            validate_query: 'Part.find_by_nr(#)',
                            is_for_out_stock: true,
                            description: "auto template default custom field, #{field}")
        # cf<<CustomField.new(name: "#{field}_default_strip_length",
        #                     type: target.custom_field_type,
        #                     is_query_value: true,
        #                     field_format: 'part',
        #                     value_query: 'Part.find_by_id(#).strip_length',
        #                     validate_query: 'Part.find_by_nr(#)',
        #                     description: "auto template default custom field,#{field}_default_strip_length")
        cf<<CustomField.new(name: "#{field}_default_strip_length",
                            type: target.custom_field_type,
                            field_format: 'label',
                            default_value: '0',
                            description: "auto template default custom field,#{field}_default_strip_length")
      else
        raise ' No such field for auto process template custom field'
    end
    return cf
  end
end