class Machine < ActiveRecord::Base
  belongs_to :resource_group
  has_one :machine_scope


end
