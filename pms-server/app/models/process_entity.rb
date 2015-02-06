class ProcessEntity < ActiveRecord::Base
  validates :nr, presence: {message: 'nr cannot be blank'}, uniqueness: {message: 'nr should be uniq'}

  belongs_to :process_template
  belongs_to :workstation_type
  belongs_to :cost_center
end
