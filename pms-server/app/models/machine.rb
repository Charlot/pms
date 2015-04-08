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
    q=production_order_items.where(state: ProductionOrderItemState::INIT)
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
    if current_item=self.for_optimise_order_items.order(machine_time: :asc).first
      current_item.update_attributes(optimise_index: current_index,
                                     state: ProductionOrderItemState::OPTIMISE_SUCCEED)
      current_index+=1

      current_index= sort_order_item_compare(current_item, current_index)
      sort_next_index_items(current_item, current_index)
    end
  end

  def sort_order_item_compare(current_item, current_index)
    puts '--------------------------------------------------compare'
    items=self.for_optimise_order_items(current_item.machine_time).where.not(id: current_item.id)
    puts "count: #{items.count}"
    puts '--------------------------------------------------compare end'
    if items.count>0
      current_kanban=current_item.kanban
      current_process=current_kanban.process_entities.first

      compares={}
      items.each do |item|
        optimise_index=0
        kanban=item.kanban
        item_process=kanban.process_entities.first

        puts '________________________________________________________________________________wire'
        puts "#{current_process.value_wire_nr.class}:#{item_process.value_wire_nr.class}".red
        puts "#{current_process.value_wire_nr}:#{item_process.value_wire_nr}".red

        puts '________________________________________________________________________________wire end'
        if current_process.value_wire_nr!=item_process.value_wire_nr
          optimise_index+=self.wire_time
        end

        if current_process.value_t1 != item_process.value_t1
          optimise_index+=self.terminal_time
        end

        if current_process.value_t2 != item_process.value_t2
          optimise_index+=self.terminal_time
        end

        if current_process.value_s1 != item_process.value_s1
          optimise_index+=self.seal_time
        end

        if current_process.value_s2 != item_process.value_s2
          optimise_index+=self.seal_time
        end
      #  if optimise_index==0
          compares[item]=optimise_index
       # end
      end

      puts '88888888888888888888888888888888'
      puts compares.keys.count
      puts compares.sort_by { |k, v| v }.to_json
      puts '99999999999999999999999999999999'
      compares.sort_by { |k, v| v }.flatten.select { |i| i.is_a?(ProductionOrderItem) }.each do |item|
        item.update_attributes(optimise_index: current_index,
                               state: ProductionOrderItemState::OPTIMISE_SUCCEED)
        current_index+=1
      end
    end
    return current_index
  end


end
