class PartProcessEntity < ActiveRecord::Base
  validates_uniqueness_of :part_id, scope: :process_entity_id

  belongs_to :part, dependent: :destroy
  belongs_to :process_entity, dependent: :destroy
end
