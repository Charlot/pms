class KanbanProcessEntity < ActiveRecord::Base
  belongs_to :Kanban
  belongs_to :ProcessEntity
end
