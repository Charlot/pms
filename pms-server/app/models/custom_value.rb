class CustomValue < ActiveRecord::Base
  belongs_to :custom_field
  belongs_to :customized, :polymorphic => true

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
                                 custom_fields: {name:  %w(t2_default_strip_length t2_strip_length)}).update_all(value: part.strip_length)
    end
  end
end
