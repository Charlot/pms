class MachineTimeRule < ActiveRecord::Base
  belongs_to :oee_code
  belongs_to :machine_type
end
