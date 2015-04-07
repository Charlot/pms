class PartPosition < ActiveRecord::Base
  belongs_to :part

  delegate :nr, to: :part,prefix: true,allow_nil: true
end
