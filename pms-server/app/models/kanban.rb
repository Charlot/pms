class Kanban < ActiveRecord::Base
  include AutoKey
  include PartBomable

  validates :nr, :uniqueness => {:message => "#{KanbanDesc::NR} 不能重复！"}
  validates :product_id, :presence => true
  after_create :create_part_bom

  #belongs_to :part
  belongs_to :product, class_name: 'Part'
  has_many :kanban_process_entities, -> { order('position ASC') }, dependent: :destroy
  has_many :process_entities, through: :kanban_process_entities
  has_many :custom_values, through: :process_entities
  has_many :process_parts, through: :process_entities
  delegate :nr, to: :part, prefix: true, allow_nil: true
  delegate :nr, to: :product, prefix: true, allow_nil: true
  delegate :custom_nr, to: :product, prefix: true, allow_nil: true
  has_many :production_order_items
  has_many :production_order_item_labels, through: :production_order_items
  has_many :production_order_item_blues

  accepts_nested_attributes_for :kanban_process_entities, allow_destroy: true

  scoped_search on: :nr
  # scoped_search on: :des_storage

  scoped_search in: :product, on: :nr
  scoped_search in: :process_entities, on: :nr
  scoped_search in: :process_entities, on: :nr, ext_method: :find_by_wire_nr

  #before_create :generate_id

  # after_create :create_part_bom
  # after_destroy :destroy_part_bom
  # after_update :update_part_bom

  has_paper_trail :only => [:quantity, :product_id, :bundle, :des_warehouse, :des_storage, :print_time, :remark, :remark2]

  def has_same_content(kanban)
    begin
      [:quantity, :product_id, :bundle, :des_warehouse, :des_storage, :remark, :remark2].each do |attr|
        puts "#{attr}--#{self.send(attr)}---#{kanban.send(attr)}".red
        if self.send(attr)!=kanban.send(attr)
          return false
        end
      end
    rescue => e
      puts e.message
      return false
    end
    return true
  end

  def self.find_by_nr_or_id(v)
    if /^0/.match(v)
        return Kanban.find_by_nr(v.sub(/\/\d+/,''))
    else
      if /\d+\/\d+/.match(v)
        return Kanban.find_by_id(v.sub(/\/\d+/, ''))
      end
    end
  end

  def self.find_by_wire_nr key, operator, value
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
      else
        {conditions: "kanbans.nr like '%#{value}%'"}
      end
      {conditions: "kanbans.nr like '%#{value}%'"}
    else
      {conditions: "kanbans.nr like '%#{value}%'"}
    end
    {conditions: "kanbans.nr like '%#{value}%'"}
  end


  # 看板中消耗额零件
  # 返回
  # {
  # 零件号:数量
  # }
  # def process_parts
  #   parts = {}
  #   process_entities.each do |pe|
  #     pe.process_parts.each { |pp|
  #       parts[pp.part_id] = pp.quantity
  #     }
  #   end
  #   parts
  # end

  #
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

  # 获得看板中步骤零件的库位
  def gathered_material
    data =[]
    process_entities.each { |pe|
      pe.process_parts.each { |pp|
        part = pp.part
        data << [part.parsed_nr, part.positions(self.id, self.product_id, pe).join(",")].join(":") if part
      }
    }
    data.join('      ')
  end

  def process_list
    process_entities.collect { |pe|
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

  #获得线长
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

  # 获得看板卡生产的线号
  def wire_nr
    @wire_nr||=if (self.ktype == KanbanType::WHITE) && self.process_entities.first && self.process_entities.first.wire
                 name = self.process_entities.first.wire.nr.split("_")
                 # puts name
                 name = (name - [name.first])
                 name.join("_")
               else
                 nil
               end
  end

  # 获得看板卡的生产的完整的零件号
  def full_wire_nr
    @full_wire_nr||=if (self.ktype == KanbanType::WHITE) && self.process_entities.first && self.process_entities.first.wire
                      self.process_entities.first.wire.nr
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

  # 电线描述
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

  # 看板没被更新一次，则版本数量会增加
  # 详细内容请看 has_paper_trail这个gem包
  def version_now
    self.versions.count
  end

  # 条形码内容
  # kanban_id/当前版本号
  def printed_2DCode
    "#{nr}/#{version_now}"
  end

  def task_time
    task_time = 0.0
    begin
      case self.ktype
        when KanbanType::WHITE
          process_entity = self.process_entities.first
          #因为全自动工时与机器有关，而要知道机器，一定要优化结束才能知道
          #所以，这里选择一张看板的最后生产的任务的机器来做判断
          if (poi = self.production_order_items.last) && (machine=poi.machine) && (machine_type_id = machine.machine_type_id)
          else
            machine_type_id = MachineType.find_by_nr('CC36').id
          end

          if machine_type_id.nil? || process_entity.nil?
            return task_time
          end

          #根据全自动看的工艺来查找出操作代码
          oee = OeeCode.find_by_nr(process_entity.oee_code)

          if oee.nil?
            return task_time
          end

          #查找全部满足的全自动工时规则，并且以断线长度升序排序
          timerule = nil
          wire_length_value = process_entity.value_wire_qty_factor.to_f
          timerule = MachineTimeRule.where(["oee_code_id = ? AND machine_type_id = ? AND min_length <= ? AND length > ?", oee.id, machine_type_id, wire_length_value, wire_length_value]).first

          if timerule.nil?
            return task_time
          end
          task_time = timerule.time * self.quantity
        when KanbanType::BLUE

      end
    rescue => e
      task_time=0
    end
    task_time.round(2)
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
    joins(:product).where('parts.nr LIKE ?', "%#{product_nr}%")
  end

  def can_put_to_produce?
    if self.ktype==KanbanType::WHITE
      return self.production_order_items.where(state: [ProductionOrderItemState::INIT,
                                                       ProductionOrderItemState::DISTRIBUTE_SUCCEED]).count==0
    elsif self.ktype==KanbanType::BLUE
      return self.production_order_item_blues.where(state: [ProductionOrderItemState::INIT,
                                                            ProductionOrderItemState::DISTRIBUTE_SUCCEED]).count==0
    end
    false
  end

  def not_in_produce?
    if self.ktype==KanbanType::WHITE
      return self.production_order_items.where(state: ProductionOrderItemState::DISTRIBUTE_SUCCEED).count==0
    elsif self.ktype==KanbanType::BLUE
      return self.production_order_item_blues.where(state: ProductionOrderItemState::DISTRIBUTE_SUCCEED).count==0
    end
    false
  end

  def generate_produce_item
    if self.ktype==KanbanType::WHITE
      return ProductionOrderItem.create(kanban_id: self.id, code: self.printed_2DCode, kanban_qty: self.quantity, kanban_bundle: self.bundle)
    elsif self.ktype==KanbanType::BLUE
      return ProductionOrderItemBlue.create(kanban_id: self.id, code: self.printed_2DCode, kanban_qty: self.quantity, kanban_bundle: self.bundle)
    end
    false
  end

  def terminate_produce_item(handler_item=nil)
    if self.ktype==KanbanType::WHITE
      true
    elsif self.ktype==KanbanType::BLUE
      blue= ProductionOrderItemBlue.
          where(kanban_id: self.id, state: ProductionOrderItemState::DISTRIBUTE_SUCCEED).first
      puts "#{handler_item.to_json}".red
      return blue.update_attributes(
          produced_qty: (handler_item.qty.nil? ? blue.produced_qty : handler_item.qty),
          state: ProductionOrderItemState::TERMINATED,
          terminated_at: handler_item.item_terminated_at,
          terminate_user: handler_item.handler_user,
          terminated_kanban_code: handler_item.kanban_code)
    end
    false
  end

  #
  private
  def generate_id
    self.nr = "KB#{Time.now.to_milli}"
  end
end
