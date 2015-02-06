class Kanban < ActiveRecord::Base
  validates :nr, :presence => true, :uniqueness => {:message => "#{KanbanEnum::NR} 不能重复！"}
  belongs_to :part
end
