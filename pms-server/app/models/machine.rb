class Machine < ActiveRecord::Base
  belongs_to :resource_group_machine, foreign_key: :resource_group_id
  has_one :machine_scope
  has_many :machine_combinations


end
