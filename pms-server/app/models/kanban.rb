class Kanban < ActiveRecord::Base
  validates :nr ,:presence => true, :uniqueness => {:message => "#{KanbanDesc::NR} 不能重复！"}
  validates :part_id, :presence => true

  belongs_to :part
  belongs_to :product, class_name:'Part'
  has_many :kanban_process_entities, dependent: :destroy
  has_many :process_entities, :through => :kanban_process_entities
  has_many :production_order, as: :orderable

  accepts_nested_attributes_for :kanban_process_entities

  has_paper_trail

  def can_update?
    if self.state == KanbanState::INIT
      true
    else
      false
    end
  end

  def version_now
    self.versions.count
  end

  # version of kanban
  def task_time
    #TODO
    self.quantity * (self.process_entities.inject(0){|sum,pe| sum+=pe.stand_time})
  end

  # Get raw materials from kanban's routing
  def get_raw_materials
    #TODO Get raw materials of Routing
  end

  # Parse 2-dimensional code of printed copy to
  # Kanban id, version and number of cycle.
  # reutrn false or
  # {id:1,
  #  version_nr:1,
  #  printed_nr:2}

  def self.parse_printed_2DCode(code)
    return false unless code =~ Regex::KANBAN_LABEL
    return false unless (splited_str = code.split('/')).count == 3

    {id: splited_str[0],
     version_nr:splited_str[1],
     printed_nr: splited_str[2]}
  end
end
