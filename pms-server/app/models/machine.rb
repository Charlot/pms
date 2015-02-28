class Machine < ActiveRecord::Base
  belongs_to :resource_group
  has_one :machine_scope
  has_many :machine_combinations


end
