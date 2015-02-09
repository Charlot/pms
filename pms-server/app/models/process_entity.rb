class ProcessEntity < ActiveRecord::Base
  validates :nr, presence: {message: 'nr cannot be blank'}, uniqueness: {message: 'nr should be uniq'}

  belongs_to :process_template
  belongs_to :workstation_type
  belongs_to :cost_center
  has_many :kanban_process_entities, dependent: :destroy

  acts_as_customizable

  def custom_field_type
    puts '***************************************8'
    puts "#{self.process_template_id}_#{ProcessTemplate.name}"
    puts '***************************************8'

    @custom_field_type || (self.process_template_id.nil? ? nil : "#{self.process_template_id}_#{ProcessTemplate.name}")
  end
end
