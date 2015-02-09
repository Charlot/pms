class Kanban < ActiveRecord::Base
  validates :nr, :presence => true, :uniqueness => {:message => "#{KanbanDesc::NR} 不能重复！"}
  belongs_to :part

  has_many :kanban_process_entities, dependent: :destroy
  has_many :process_entities, :through => :kanban_process_entities
  has_many :production_order, as: :orderable

  def can_update?
    if self.state == KanbanState::INIT
      true
    else
      false
    end
  end

  # Get raw materials from kanban's routing
  def get_raw_materials
    #TODO Get raw materials of Routing
  end
end
