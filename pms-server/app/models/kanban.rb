class Kanban < ActiveRecord::Base
  validates :nr, :presence => true, :uniqueness => {:message => "#{KanbanDesc::NR} 不能重复！"}
  validates :part_id, :presence => true

  belongs_to :part
  belongs_to :product, class_name: 'Part'
  delegate :process_entities,to: :part
  has_many :production_order, as: :orderable

  # after_create :create_part_bom
  # after_destroy :destroy_part_bom
  # after_update :update_part_bom

  has_paper_trail

  def create_part_bom
    #TODO Kanban Update Part Bom
    # part=self.part
    # product=self.product
    # unless PartBom.where(part_id: product.id, bom_item_id: part.id).first
    #   PartBom.create(part_id: product.id, bom_item_id: part.id, quantity: 1)
    # end
  end

  def destroy_part_bom
    #TODO Kanban Update Part Bom
    # 要考虑相同KB的量，如果KB具有多张，则要特殊处理
    # part=self.part
    # product=self.product
    # unless Kanban.where(part_id: part.id, product_id: product.id).where('id<>?', self.id).first
    #   if pb= PartBom.where(part_id: product.id, bom_item_id: part.id).first
    #     pb.destroy
    #   end
    # end
  end

  def update_part_bom
    #TODO Kanban Update Part Bom
  end

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
    self.quantity * (self.process_entities.inject(0) { |sum, pe| sum+=pe.stand_time })
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
     version_nr: splited_str[1],
     printed_nr: splited_str[2]}
  end
end
