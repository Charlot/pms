class PartProcessEntity < ActiveRecord::Base
  validates_uniqueness_of :part_id, scope: :process_entity_id

  belongs_to :part
  belongs_to :process_entity
end
