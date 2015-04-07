class Machine < ActiveRecord::Base
  belongs_to :resource_group_machine, foreign_key: :resource_group_id
  has_one :machine_scope
  has_many :machine_combinations
  has_many :production_order_items
  OPTIMISE_TIME_MATCH_MAP={wire_nr: :wire_time, t1: :terminal_time, t2: :terminal_time,
                           s1: :seal_time, s2: :seal_time,
                           w2: :wire_time, t3: :terminal_time, t4: :terminal_time, s3: :seal_time, s4: :seal_time}


  def optimise_time_by_kanban(kanban)
    optimise_time=0
    template=kanban.process_entities.first.process_template
    OPTIMISE_TIME_MATCH_MAP.keys.each do |k|
      if template.send("field_#{k}")
        optimise_time+=self.send(OPTIMISE_TIME_MATCH_MAP[k])
      end
    end
    return optimise_time
  end

  def for_optimise_order_items(machine_time=nil)
    q=production_order_items.where(state:ProductionOrderItemState::INIT)
    q= q.where(machine_time: machine_time) unless machine_time.nil?
    q
  end

  def sort_order_item
    current_index=1
    if current_item=self.for_optimise_order_items.order(machine_time: :asc).first
      current_item.update_attributes(optimise_index: current_index,
                                     state: ProductionOrderItemState::OPTIMISE_SUCCEED)
      current_index+=1
      current_index=sort_order_item_compare(current_item, current_index)
      sort_next_index_items(current_item, current_index)
    end
  end

  def sort_next_index_items(prev_item, current_index)
    if current_item=self.for_optimise_order_items.where('machine_time>?', prev_item.machine_time).order(machine_time: :asc).first
      current_item.update_attributes(optimise_index: current_index,
                                     state: ProductionOrderItemState::OPTIMISE_SUCCEED)
      current_index+=1

      current_index= sort_order_item_compare(current_item, current_index)
      sort_next_index_items(current_item, current_index)
    end
  end

  def sort_order_item_compare(current_item, current_index)
    items=self.for_optimise_order_items(current_item.machine_time).where.not(id: current_item.id)
    if items.count>0
      current_kanban=current_item.kanban
      current_template=current_kanban.process_entities.first.process_template

      compares={}
      items.each do |item|
        optimise_index=0
        kanban=item.kanban
        template=kanban.process_entities.first.process_template

        if current_template.value_wire_nr!=template.value_wire_nr
          optimise_index+=self.wire_time
        end

        if current_template.value_t1 != template.value_t1
          optimise_index+=self.terminal_time
        end

        if current_template.value_t2 != template.value_t2
          optimise_index+=self.terminal_time
        end

        if current_template.value_s1 != template.value_s1
          optimise_index+=self.seal_time
        end

        if current_template.value_s2 != template.value_s2
          optimise_index+=self.seal_time
        end

        compares[optimise_index]=item
      end
      compares.sort.values.each do |item|
        item.update_attributes(optimise_index: current_index,
                               state: ProductionOrderItemState::OPTIMISE_SUCCEED)
        current_index+=1
      end
    end
    return current_index
  end


end
