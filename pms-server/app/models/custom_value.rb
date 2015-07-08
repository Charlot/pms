class CustomValue < ActiveRecord::Base
  belongs_to :custom_field
  belongs_to :customized, :polymorphic => true
  after_update :update_process_entity_part
  include PartBomable


  has_paper_trail

  def initialize(attributes=nil, *args)
    super
    if new_record? && custom_field && (customized_type.blank? || (customized && customized.new_record?))
      self.value ||= custom_field.default_value
    end
  end

  def self.value_by_format(field, value)
    if field.field_format=='part'
      (part=Part.find_by_id(value)).nil? ? '' : part.nr
    else
      value.nil? ? '' : value
    end
  end

  def self.update_part_strip_length(part)
    joins(:custom_field).where(custom_fields: {name: 't1'}, value: part.id).each do |tcv|
      joins(:custom_field).where(customized_id: tcv.customized_id,
                                 customized_type: tcv.customized_type,
                                 custom_fields: {name: %w(t1_default_strip_length t1_strip_length)}).update_all(value: part.strip_length)
    end

    joins(:custom_field).where(custom_fields: {name: 't2'}, value: part.id).each do |tcv|
      joins(:custom_field).where(customized_id: tcv.customized_id,
                                 customized_type: tcv.customized_type,
                                 custom_fields: {name: %w(t2_default_strip_length t2_strip_length)}).update_all(value: part.strip_length)
    end
  end

  def update_process_entity_part
    if self.customized.is_a?(ProcessEntity)
      pe=self.customized
      arrs=pe.process_parts.pluck(:id)

      if pe.process_template.type==ProcessType::AUTO
        pe.custom_values.each do |cv|
          cf=cv.custom_field
          if CustomFieldFormatType.part?(cf.field_format) && cf.is_for_out_stock
            qty= pe.process_part_quantity_by_cf(cf.name.to_sym).to_f
            if (part=Part.find_by_id(cv.value)) && (part.type==PartType::MATERIAL_WIRE) && qty>10
              qty=qty/1000
            end if Setting.auto_convert_material_length?

            if ppp=pe.process_parts.where(custom_value_id: cv.id, part_id: cv.value).first
              ppp.update_attributes!(quantity: qty)
              arrs.delete(ppp.id)
            else
              pe.process_parts<<ProcessPart.new(part_id: cv.value, quantity: qty, custom_value_id: cv.id)
            end
          end
        end
        pe.process_parts.where(id: arrs).destroy_all
        pe.save
      elsif pe.process_template.type==ProcessType::SEMI_AUTO

      end
    end
  end
end
