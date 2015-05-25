class MachineTimeRule < ActiveRecord::Base
  belongs_to :oee_code
  belongs_to :machine_type

  delegate :nr,to: :machine_type,prefix: true,allow_nil: true
  delegate :nr,to: :oee_code, prefix: true,allow_nil: true
end
