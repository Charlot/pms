class KanbanProcessEntity < ActiveRecord::Base
  validates_uniqueness_of :kanban_id, :scope => :process_entity_id
  belongs_to :kanban
  belongs_to :process_entity
end
