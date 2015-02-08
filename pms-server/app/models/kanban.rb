class Kanban < ActiveRecord::Base
  validates :nr, :presence => true, :uniqueness => {:message => "#{KanbanDesc::NR} 不能重复！"}
  belongs_to :part

  has_many :kanban_process_entities
  has_many :process_entities, :through => :kanban_process_entities
  has_many :production_order, as: :orderable
end
