class KanbanProcessEntity < ActiveRecord::Base
  belongs_to :kanban
  belongs_to :process_entity
end
