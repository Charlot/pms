class Storage < ActiveRecord::Base
  #belongs_to :warehouse
  belongs_to :part
  belongs_to :position

  delegate :nr, to: :part,prefix: true, allow_nil: true
  delegate :detail, to: :position, prefix: true, allow_nil: true

  validates_uniqueness_of :part_id, :scope => :position_id
end
