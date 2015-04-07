class ProcessPart < ActiveRecord::Base
  belongs_to :part
  belongs_to :process_entity

  delegate :nr, to: :part,prefix: true, allow_nil: true
  delegate :parsed_nr, to: :part, allow_nil: true
end
