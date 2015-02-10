class ProcessPart < ActiveRecord::Base
  belongs_to :part
  belongs_to :process_entity
end
