class ProcessEntity < ActiveRecord::Base
  validates :nr, presence: {message: 'nr cannot be blank'}, uniqueness: {message: 'nr should be uniq'}

  belongs_to :process_template
  belongs_to :workstation_type
  belongs_to :cost_center
  has_many :kanban_process_entities, dependent: :destroy
  has_many :process_parts
  has_many :parts, through: :process_parts
  delegate :custom_fields, to: :process_template

  acts_as_customizable

  # after_create :build_process_parts

  def custom_field_type
    puts '***************************************8'
    puts "#{self.process_template_id}_#{ProcessTemplate.name}"
    puts '***************************************8'

    @custom_field_type || (self.process_template_id.nil? ? nil : "#{self.process_template_id}_#{ProcessTemplate.name}")
  end


  def process_part_quantity_by_cf(cf_name)
    if quantity_cf_name=ProcessTemplateAuto.process_part_quantity_field(cf_name)
      puts "#{self.to_json}*********************#{quantity_cf_name}"
      self.send(quantity_cf_name)
    end
  end

  # for auto process entity
  def t1_strip_length
    puts "-----#{self.value_t1_strip_length}---#{self.value_t1_default_strip_length}***************************"
    @t1_strip_length ||=(self.value_t1_strip_length || self.value_t1_default_strip_length)
  end


  def t2_strip_length
    @t2_strip_length||=(self.value_t2_strip_length || self.value_t2_default_strip_length)
  end

  # def build_process_parts
  #   if ProcessType.auto?(self.process_template.type)
  #     self.custom_values.each do |cv|
  #       cf=cv.custom_field
  #       if CustomFieldFormatType.part?(cf.field_format) && cf.is_for_out_stock
  #         self.process_parts<<ProcessPart.new(part_id: cv.value, quantity: self.process_part_quantity_by_cf(cf.name))
  #       end
  #     end
  #   end
  # end
end
