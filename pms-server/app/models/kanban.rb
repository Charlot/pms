class Kanban < ActiveRecord::Base
  include AutoKey
  validates :nr, :uniqueness => {:message => "#{KanbanDesc::NR} 不能重复！"}
  validates :product_id, :presence => true


  #belongs_to :part
  belongs_to :product, class_name: 'Part'
  #delegate :process_entities,to: :part
  has_many :kanban_process_entities ,dependent: :destroy
  has_many :process_entities, through: :kanban_process_entities
  delegate :nr, to: :part,prefix: true, allow_nil: true
  delegate :nr, to: :product,prefix: true, allow_nil: true
  delegate :custom_nr, to: :product,prefix: true,allow_nil: true
  #delegate :custom_nr, to: :part, prefix: true,allow_nil: true
  has_many :production_order, as: :orderable

  accepts_nested_attributes_for :kanban_process_entities, allow_destroy: true

  #before_create :generate_id

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
    if [KanbanState::INIT,KanbanState::LOCKED].include?(state)
      true
    else
      false
    end
  end

  def wire_length
    pe = self.process_entities.first
    if pe && pe.respond_to?("value_of_wire_qty_factor")
      pe.send("value_of_wire_qty_factor")
    else
      0
    end
  end

  def can_destroy?
    if [KanbanState::INIT,KanbanState::LOCKED,KanbanState::DELETED].include?(state)
      true
    else
      false
    end
  end

  def wire_nr
    if (self.ktype == KanbanType::WHITE) && self.process_entities.first && self.process_entities.first.value_default_wire_nr
      self.process_entities.first.value_default_wire_nr
    else
      nil
    end
  end

  #看板对应的物料清单
  def material
    if (self.ktype == KanbanType::WHITE) && self.process_entities.first
      self.process_entities.first.process_parts.select{|pp| PartType.is_material?(pp.part.type)}.collect{|pp|pp.part}
    else
      []
    end
  end

  def print_time
    self[:print_time].localtime.strftime("%Y-%m-%d %H:%M:%S") if self[:print_time]
  end

  def version_now
    self.versions.count
  end

  def printed_2DCode
    "#{id}/#{version_now}"
  end

  # version of kanban
  def task_time
    sum = (self.process_entities.inject(0) { |sum, pe| sum+=pe.stand_time if pe.stand_time })
    self.quantity * (sum.nil? ? 0 : sum)
  end

  def source_position
    "#{self.source_warehouse} #{self.source_storage}"
  end

  def desc_position
    "#{self.des_warehouse} #{self.des_storage}"
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
    return false unless (splited_str = code.split('/')).count == 2

    {id: splited_str[0],
     version_nr: splited_str[1]
    }
  end

  # part_nr,product_nr
  def self.search(part_nr="",product_nr="")
    joins(:product).where('parts.nr LIKE ?',"%#{product_nr}%")
  end

  #
  private
  def generate_id
    self.nr = "KB#{Time.now.to_milli}"
  end
end
