class Kanban < ActiveRecord::Base
  include AutoKey
  include Destroyable
  include KanbanAutoCountable
  include PartBomable


  validates :nr, :uniqueness => {:message => "#{KanbanDesc::NR} 不能重复！"}
  validates :product_id, :presence => true
  after_create :create_part_bom
  after_update :change_production_order_items_kanban_qty

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
  scoped_search on: :des_storage

  scoped_search in: :product, on: :nr
  scoped_search in: :process_entities, on: :nr
  scoped_search in: :process_entities, on: :nr, ext_method: :find_by_wire_nr


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
      return Kanban.find_by_nr(v.sub(/\/\d+/, ''))
    else
      if /\d+\/\d+/.match(v)
        return Kanban.find_by_id(v.sub(/\/\d+/, ''))
      end
    end
  end

  def self.find_by_wire_nr key, operator, value
    puts "#{value}.....#{key}....#{operator}..........................................."
    q={conditions: "kanbans.nr like '%#{value}%'"}

    parts = Part.where("nr LIKE '%#{value}%'").map(&:id)
    if parts.count > 0

      process = ProcessEntity.joins(custom_values: :custom_field).where(
          "custom_values.value IN (#{parts.join(',')}) AND custom_fields.field_format = 'part'"
      ).pluck(:id)
      kanbans=[]
      if process.count > 0
        kanbans = Kanban.joins(:process_entities).where("process_entities.id IN(#{process.join(',')})").pluck(:id)
      else
        q= {conditions: "kanbans.nr like '%#{value}%'"}
      end
      if kanbans.count > 0
        q= {conditions: "kanbans.id IN(#{kanbans.join(',')})"}
      end
    end
    state=KanbanState.get_value_by_display(value)
    if state
      q={conditions: "kanbans.nr like '%#{value}%' or kanbans.state=#{state}"}
    end
    return q
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
    # process_entities.each { |pe|
    #   pe.process_parts.distinct.each { |pp|
    #     part = pp.part
    #     data << [part.parsed_nr, part.positions(self.id, self.product_id, pe).join(",")].join(":") if part
    #   }
    # }
    process_parts.distinct.each { |pp|
      part = pp.part
      data << [part.parsed_nr, part.positions(self.id, self.product_id, pp.process_entity).join(",")].join(":") if part
    }
    data.uniq.join('      ')
  end

  def process_list
    puts '--------------------------------------------------------------------'.blue
    puts process_entities.to_json.blue
    puts process_entities.count
    puts '--------------------------------------------------------------------'.blue

    process_entities.reload.collect { |pe|
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

  def old_printed_2DCode
    "#{id}/#{version_now}"
  end

  def machine_nr
    #self.production_order_items.last.nil? ? "" : self.production_order_items.last.machine.nr
  end

  def machine_type
    #self.production_order_items.last.nil? ? "" : self.production_order_items.last.machine.machine_type.nr
  end

  def task_time
    task_time = 0.0
    # begin
    case self.ktype
      when KanbanType::WHITE
        unless (process_entity = self.process_entities.first).nil?
          task_time = process_entity.get_process_entity_worktime(self.production_order_items.last)
        end

        task_time *= self.quantity
      when KanbanType::BLUE
        self.process_entities.each_with_index do |process_entity, i|
          puts "-------#{i}..#{process_entity.process_template.code}----#{process_entity.nr}".yellow
          task_time += process_entity.get_process_entity_worktime
        end

        task_time = task_time * self.quantity
    end
    # rescue => e
    #   task_time=0
    # end
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

  def generate_produce_item(auto=true)
    if self.ktype==KanbanType::WHITE
      return ProductionOrderItem.create(kanban_id: self.id, code: self.printed_2DCode, kanban_qty: self.quantity, kanban_bundle: self.bundle, auto: auto)
    elsif self.ktype==KanbanType::BLUE
      return ProductionOrderItemBlue.create(kanban_id: self.id, code: self.printed_2DCode, kanban_qty: self.quantity, kanban_bundle: self.bundle, auto: auto)
    end
    false
  end

  # handler item is from file handle kanban
  def terminate_produce_item(handler_item=nil)
    if self.ktype==KanbanType::WHITE
      # if handler_item.blank?
      #   #item=self.generate_produce_item(false)
      #  # item.update_attributes(produced_qty: item.kanban_qty, state: ProductionOrderItemState::TERMINATED)
      # else
      #   return true
      # end
      return true
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


  def change_production_order_items_kanban_qty
    if self.bundle_changed? || self.quantity_changed?
      if Setting.kanban_qty_change_order?
        self.production_order_items.where(state: ProductionOrderItem.can_change_kanban_qty_states)
            .update_all(kanban_bundle: self.bundle, kanban_qty: self.quantity)
      end
    end
  end
end
