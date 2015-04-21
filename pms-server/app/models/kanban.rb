class Kanban < ActiveRecord::Base
  include AutoKey
  validates :nr, :uniqueness => {:message => "#{KanbanDesc::NR} 不能重复！"}
  validates :product_id, :presence => true


  #belongs_to :part
  belongs_to :product, class_name: 'Part'
  has_many :kanban_process_entities, -> { order('position ASC') }, dependent: :destroy
  has_many :process_entities, through: :kanban_process_entities
  has_many :custom_values, through: :process_entities
  delegate :nr, to: :part, prefix: true, allow_nil: true
  delegate :nr, to: :product, prefix: true, allow_nil: true
  delegate :custom_nr, to: :product, prefix: true, allow_nil: true
  has_many :production_order_items

  accepts_nested_attributes_for :kanban_process_entities, allow_destroy: true

  scoped_search on: :nr
  scoped_search in: :product,on: :nr
  scoped_search in: :process_entities, on: :nr
  scoped_search in: :process_entities, on: :nr, ext_method: :find_by_wire_nr

  #before_create :generate_id

  # after_create :create_part_bom
  # after_destroy :destroy_part_bom
  # after_update :update_part_bom

  has_paper_trail

  def self.find_by_wire_nr key,operator,value
    parts = Part.where("nr LIKE '%_#{value}%'").map(&:id)
    if parts.count > 0
      process = ProcessEntity.joins(custom_values: :custom_field).where(
          "custom_values.value IN (#{parts.join(',')}) AND custom_fields.field_format = 'part'"
      ).map(&:id)
      if process.count > 0
        kanbans = Kanban.joins(:process_entities).where("process_entities.id IN(#{process.join(',')})").map(&:id)
      end
      if kanbans.count > 0
        return {conditions: "kanbans.id IN(#{kanbans.join(',')})"}
      end
    else
      {conditions: "kanbans.nr like '%#{value}%'"}
    end
  end

  def create_part_bom
    #TODO Kanban Update Part Bom
    # part=self.part
    # product=self.product
    # unless PartBom.where(part_id: product.id, bom_item_id: part.id).first
    #   PartBom.create(part_id: product.id, bom_item_id: part.id, quantity: 1)
    # end
  end

  def destroy_part_bom
    # 要考虑相同KB的量，如果KB具有多张，则要特殊处理
    # part=self.part
    # product=self.product
    # unless Kanban.where(part_id: part.id, product_id: product.id).where('id<>?', self.id).first
    #   if pb= PartBom.where(part_id: product.id, bom_item_id: part.id).first
    #     pb.destroy
    #   end
    # end
  end

  #硬编码
  #只有在2220,2221,2410这几个步骤的时候，才需要现实取料信息
  def gathered_material
    data =[]
    process_entities.each { |pe|
      pe.process_parts.each { |pp|
        part = pp.part
        data << [part.parsed_nr, part.positions(self.id,self.product_id,pe).join(",")].join(":") if part
      }
    }
    data.join('      ')
  end

  def process_list
    process_entities.collect{|pe|
      pe.nr
    }.join(",")
  end

  def update_part_bom
    #TODO Kanban Update Part Bom
  end

  def can_update?
    if [KanbanState::INIT, KanbanState::LOCKED, KanbanState::RELEASED].include?(state)
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
    if [KanbanState::INIT, KanbanState::LOCKED, KanbanState::DELETED].include?(state)
      true
    else
      false
    end
  end

  def wire_nr
    if (self.ktype == KanbanType::WHITE) && self.process_entities.first && self.process_entities.first.wire
      name = self.process_entities.first.wire.nr.split("_")
      # puts name
      name = (name - [name.first])
      name.join("_")
    else
      nil
    end
  end

  def wire_length
    if (self.ktype == KanbanType::WHITE) && (pe = self.process_entities.first)
      pe.value_wire_qty_factor
    else
      nil
    end
  end

  def wire_description
    if (self.ktype == KanbanType::WHITE) && self.process_entities.first && self.process_entities.first.wire
      self.process_entities.first.wire.custom_nr
    else
      nil
    end
  end

  #看板对应的物料清单
  def material
    if (self.ktype == KanbanType::WHITE) && self.process_entities.first
      self.process_entities.first.process_parts.select { |pp| PartType.is_material?(pp.part.type) }.collect { |pp| pp.part }
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
  def self.search(part_nr="", product_nr="")
    kanbans = joins(:product).where('parts.nr LIKE ?', "%#{product_nr}%")
  end

  #
  private
  def generate_id
    self.nr = "KB#{Time.now.to_milli}"
  end
end
