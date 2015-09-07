class PartPosition < ActiveRecord::Base
  belongs_to :part

  scoped_search on: :storage
  scoped_search in: :part, on: :nr
  delegate :nr, to: :part,prefix: true,allow_nil: true
end
