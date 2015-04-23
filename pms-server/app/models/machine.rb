class Machine < ActiveRecord::Base
  belongs_to :resource_group_machine, foreign_key: :resource_group_id
  belongs_to :machine_type
  has_one :machine_scope
  has_many :machine_combinations
  has_many :production_order_items

  delegate :nr, to: :machine_type, prefix: true, allow_nil: true

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

  def for_sort_order_items(machine_time=nil)
    q=production_order_items.where(state: ProductionOrderItemState::OPTIMISE_SUCCEED)
    q= q.where(machine_time: machine_time) unless machine_time.nil?
    q
  end


  def sort_order_item
    current_index=1
    if current_item=self.for_sort_order_items.order(machine_time: :asc).first
      # raise 'nnnnn'
      current_item.update_attributes(optimise_index: current_index,
                                     state: ProductionOrderItemState::OPTIMISE_SUCCEED)
      current_index+=1
      current_index, compared_item=sort_order_item_compare(current_item, current_index)
      sort_next_index_items(compared_item, current_index)
    end
  end

  def sort_next_index_items(current_item, current_index)
    if current_item
      current_index, compared_item= sort_order_item_compare(current_item, current_index)
      sort_next_index_items(compared_item, current_index)
    end
    # if current_item=self.for_optimise_order_items.order(machine_time: :asc).first
    #   current_item.update_attributes(optimise_index: current_index,
    #                                  state: ProductionOrderItemState::OPTIMISE_SUCCEED)
    #   current_index+=1
    #
    #   current_index= sort_order_item_compare(current_item, current_index)
    #   sort_next_index_items(current_item, current_index)
    # end
  end

  def sort_order_item_compare(current_item, current_index)
    puts '--------------------------------------------------compare'
    items=self.for_sort_order_items.where.not(id: current_item.id)
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

        t_arr=[current_process.value_t1, current_process.value_t2, item_process.value_t1, item_process.value_t2]
        optimise_index+=(self.terminal_time*(t_arr.uniq.size-2))


        s_arr=[current_process.value_s1, current_process.value_s2, item_process.value_s1, item_process.value_s2]
        optimise_index+=(self.seal_time*(s_arr.uniq.size-2))

        # if !((t1==tc1 && t2==tc2) || (t1==tc2 && t2==tc1))
        #
        # end

        # puts '________________________________________________________________________________t1'
        # puts "#{current_process.value_t1}:#{item_process.value_t1}".red
        #
        # puts '________________________________________________________________________________t1 end'
        #
        #
        # if current_process.value_t1 != item_process.value_t1
        #   optimise_index+=self.terminal_time
        # end
        #
        # puts '________________________________________________________________________________t2'
        # puts "#{current_process.value_t2}:#{item_process.value_t2}".red
        #
        # puts '________________________________________________________________________________t2 end'
        #
        # if current_process.value_t2 != item_process.value_t2
        #   optimise_index+=self.terminal_time
        # end

        # if current_process.value_s1 != item_process.value_s1
        #   optimise_index+=self.seal_time
        # end
        #
        # if current_process.value_s2 != item_process.value_s2
        #   optimise_index+=self.seal_time
        # end
        # if optimise_index==0
        compares[item]=optimise_index
        # break if optimise_index==0
        # end
      end


      puts '88888888888888888888888888888888'.yellow
      puts compares.keys.count
      puts compares.sort_by { |k, v| v }.to_json
      puts '9999999999999999999999999999999'.yellow
      compared_item=nil
      if compared_item_arr= compares.sort_by { |k, v| v }.first
        compared_item=compared_item_arr[0]
        compared_item.update_attributes(optimise_index: current_index, state: ProductionOrderItemState::OPTIMISE_SUCCEED)
        current_index+=1
      end
      # compares.sort_by { |k, v| v }.flatten.select { |i| i.is_a?(ProductionOrderItem) }.each do |item|
      #   item.update_attributes(optimise_index: current_index,
      #                          state: ProductionOrderItemState::OPTIMISE_SUCCEED)
      #   current_index+=1
      # end
    end
    return current_index, compared_item
  end


end
