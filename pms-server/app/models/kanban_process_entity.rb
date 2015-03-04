class KanbanProcessEntity < ActiveRecord::Base
  validates_uniqueness_of :kanban_id, scope: :process_entity_id

  belongs_to :kanban, dependent: :destroy
  belongs_to :process_entity, dependent: :destroy
end
