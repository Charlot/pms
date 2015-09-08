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

  def for_sort_order_items(machine_time=nil, current_process=nil, keys=nil)
    q=production_order_items.where(state: ProductionOrderItemState.sort_states)
    q= q.where(machine_time: machine_time) unless machine_time.nil?
    if current_process

      parts=[]
      keys.each do |k|
        if (v=current_process.send("value_#{k}"))
          parts<<v
        end
      end
      if parts.count>0
        q= q.joins({kanban: {process_entities: {custom_values: :custom_field}}}).where(
            "custom_values.value IN (#{parts.join(',')}) AND custom_fields.field_format = 'part'"
        )
      end
      puts "call current process optimise......#{parts}".yellow
    end
    q
  end

  def sort_order_item
    current_index=1
    if current_item=self.for_sort_order_items.order(machine_time: :asc).first
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
  end

  def sort_order_item_compare(current_item, current_index)
    current_kanban=current_item.kanban
    current_process=current_kanban.process_entities.first

    puts '--------------------------------------------------compare'

    # 排端子一样的
    # items=self.for_sort_order_items(nil, current_process, true).where.not(id: current_item.id)
    # if items.count==0
    # 排存在零件一样的
    items=self.for_sort_order_items(nil, current_process, ['t1']).where.not(id: current_item.id)
    if items.count==0
      items=self.for_sort_order_items(nil, current_process, ['t2']).where.not(id: current_item.id)
      if items.count==0
        # 重新开始新的比较
        items=self.for_sort_order_items.where.not(id: current_item.id)
      end
    end
    # end

    puts "count: #{items.count}"
    puts '--------------------------------------------------compare end'
    if items.count>0

      compares={}
      items.each do |item|
        optimise_index=0
        kanban=item.kanban
        item_process=kanban.process_entities.first

        if current_process.value_wire_nr!=item_process.value_wire_nr
          optimise_index+=self.wire_time
        end

        if current_process.value_wire_qty_factor!=item_process.value_wire_qty_factor
          optimise_index+=self.wire_length_time
        end

        ct1=current_process.value_t1
        ct2=current_process.value_t2
        it1= item_process.value_t1
        it2= item_process.value_t2
        puts '------------------------------------------------------------------'
        puts "#{ct1}----#{ct2}----------#{it1}----------#{it2}"
        puts "#{ct1.class}----#{ct2.class}----------#{it1.class}----------#{it2.class}"
        puts "#{ct1==it1}------------#{ct2==it2}"
        puts '------------------------------------------------------------------'

        if ct1==it1
          if ct2==it2
            optimise_index+=0
          else
            optimise_index+=self.terminal_time
          end
        elsif ct1==it2
          if ct2==it1
            optimise_index+=0
          else
            optimise_index+=self.terminal_time
          end
        elsif ct1!=it1
          if ct2==it2
            optimise_index+=self.terminal_time
          else
            optimise_index+=self.terminal_time*2
          end
        elsif ct1!=it2
          if ct2==it1
            optimise_index+=self.terminal_time
          else
            optimise_index+=self.terminal_time*2
          end
        end

        # if ct1==it1 && ct2==it2
        #   optimise_index+=0
        #   puts '------------------------------1'
        # elsif ct1!=it1 && ct2==it2
        #   optimise_index+=self.terminal_time
        #   puts '------------------------------2'
        # elsif ct1!=it1 && ct2!=it2
        #   optimise_index+=self.terminal_time*2
        #   puts '------------------------------3'
        # elsif ct1!=it2 && ct2!=it1
        #   optimise_index+=self.terminal_time*2
        #   puts '------------------------------4'
        # elsif ct1!=it2 && ct2==it1
        #   optimise_index+=self.terminal_time
        #   puts '------------------------------5'
        # elsif ct1==it1 && ct2!=it2
        #   optimise_index+=self.terminal_time
        #
        #   puts '------------------------------6'
        # elsif ct1==it2 && ct2!=it1
        #   optimise_index+=self.terminal_time
        #
        #   puts '------------------------------7'
        # elsif ct1==it2 && ct2==it1
        #   optimise_index+=0
        #   puts '------------------------------8'
        # end


        cs1=current_process.value_s1
        cs2=current_process.value_s2
        is1= item_process.value_s1
        is2= item_process.value_s2

        puts '------------------------------------------------------------------'
        puts "#{cs1}----#{cs2}----------#{cs1}----------#{cs2}"
        puts '------------------------------------------------------------------'

        if cs1==is1
          if cs2==is2
            optimise_index+=0
          else
            optimise_index+=self.seal_time
          end
        elsif cs1==is2
          if cs2==is1
            optimise_index+=0
          else
            optimise_index+=self.seal_time
          end
        elsif cs1!=is1
          if cs2==is2
            optimise_index+=self.seal_time
          else
            optimise_index+=self.seal_time*2
          end
        elsif cs1!=is2
          if cs2==is1
            optimise_index+=self.seal_time
          else
            optimise_index+=self.seal_time*2
          end
        end

        #
        # if cs1==is1 && cs2==is2
        #   optimise_index+=0
        # elsif cs1!=is1 && cs2==is2
        #   optimise_index+=self.seal_time
        # elsif cs1!=is1 && cs2!=is2
        #   optimise_index+=self.seal_time*2
        # elsif cs1!=is2 && cs2!=is1
        #   optimise_index+=self.seal_time*2
        # elsif cs1!=is2 && cs2==is1
        #   optimise_index+=self.seal_time
        # elsif cs1==is1 && cs2!=is2
        #   optimise_index+=self.seal_time
        # elsif cs1==is2 && cs2!=is1
        #   optimise_index+=self.seal_time
        # elsif cs1==is2 && cs2==is1
        #   optimise_index+=0
        # end

        compares[item]=optimise_index
        #item.update_attributes(machine_time: optimise_index)
      end


      puts '8888888888888888888888888888888888888888888888888888'.yellow
      puts compares.to_json
      puts compares.sort_by { |k, v| v }.to_json
      puts "9999999999999999999999999999999        :::#{compares.keys.count}".yellow
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

  # def sort_order_item_compare(current_item, current_index)
  #   current_kanban=current_item.kanban
  #   current_process=current_kanban.process_entities.first
  #
  #
  #   puts '--------------------------------------------------compare'
  #
  #   # 排端子一样的
  #   # items=self.for_sort_order_items(nil, current_process, true).where.not(id: current_item.id)
  #   # if items.count==0
  #   # 排存在零件一样的
  #   items=self.for_sort_order_items(nil, current_process).where.not(id: current_item.id)
  #   if items.count==0
  #     # 重新开始新的比较
  #     items=self.for_sort_order_items.where.not(id: current_item.id)
  #   end
  #   # end
  #
  #   puts "count: #{items.count}"
  #   puts '--------------------------------------------------compare end'
  #   if items.count>0
  #
  #     compares={}
  #     items.each do |item|
  #       optimise_index=0
  #       kanban=item.kanban
  #       item_process=kanban.process_entities.first
  #
  #       puts '________________________________________________________________________________wire'
  #       puts "#{current_process.value_wire_nr.class}:#{item_process.value_wire_nr.class}".red
  #       puts "#{current_process.value_wire_nr}:#{item_process.value_wire_nr}".red
  #
  #       puts '________________________________________________________________________________wire end'
  #       if current_process.value_wire_nr!=item_process.value_wire_nr
  #         optimise_index+=self.wire_time
  #       end
  #
  #       if current_process.value_wire_qty_factor!=item_process.value_wire_qty_factor
  #         optimise_index+=self.wire_length_time
  #       end
  #
  #       # if (current_process_part=Part.find_by_id(current_process.value_wire_nr))&& (item_process_part=Part.find_by_id(item_process.value_wire_nr))
  #       #   if current_process_part.cross_section!=item_process_part.cross_section
  #       #     optimise_index+=self.wire_length_time
  #       #   end
  #       # end
  #
  #       t_arr=[current_process.value_t1, current_process.value_t2, item_process.value_t1, item_process.value_t2]
  #       optimise_index+=(self.terminal_time*(t_arr.uniq.size-2)) #if (t_arr.uniq.size-2)>0
  #
  #       # te1= (current_process.value_t1==current_process.value_t2)
  #       # te2= (item_process.value_t1==item_process.value_t2)
  #       # if(te1!=te2)
  #       #   optimise_index+=self.terminal_time
  #       # end
  #       puts "****--------------------------#{t_arr}-----------#{t_arr.uniq}------###{(t_arr.uniq.size-2)}".red
  #
  #
  #       s_arr=[current_process.value_s1, current_process.value_s2, item_process.value_s1, item_process.value_s2]
  #       optimise_index+=(self.seal_time*(s_arr.uniq.size-2)) #if (s_arr.uniq.size-2)>0
  #       # se1= (current_process.value_s1==current_process.value_s2)
  #       # se2= (item_process.value_s1==item_process.value_s2)
  #       # if(se1!=se2)
  #       #   optimise_index+=self.terminal_time
  #       # end
  #       puts "****--------------------------#{s_arr}-----------#{s_arr.uniq}-----####{(s_arr.uniq.size-2)}".red
  #
  #       # if !((t1==tc1 && t2==tc2) || (t1==tc2 && t2==tc1))
  #       #
  #       # end
  #
  #       # puts '________________________________________________________________________________t1'
  #       # puts "#{current_process.value_t1}:#{item_process.value_t1}".red
  #       #
  #       # puts '________________________________________________________________________________t1 end'
  #       #
  #       #
  #       # if current_process.value_t1 != item_process.value_t1
  #       #   optimise_index+=self.terminal_time
  #       # end
  #       #
  #       # puts '________________________________________________________________________________t2'
  #       # puts "#{current_process.value_t2}:#{item_process.value_t2}".red
  #       #
  #       # puts '________________________________________________________________________________t2 end'
  #       #
  #       # if current_process.value_t2 != item_process.value_t2
  #       #   optimise_index+=self.terminal_time
  #       # end
  #
  #       # if current_process.value_s1 != item_process.value_s1
  #       #   optimise_index+=self.seal_time
  #       # end
  #       #
  #       # if current_process.value_s2 != item_process.value_s2
  #       #   optimise_index+=self.seal_time
  #       # end
  #       # if optimise_index==0
  #       compares[item]=optimise_index
  #       puts '--------------------------------'.red
  #       puts optimise_index
  #       puts '----------------------------------'.red
  #       # break if optimise_index==0
  #       # end
  #     end
  #
  #
  #     puts '8888888888888888888888888888888888888888888888888888'.yellow
  #     puts compares.keys.count
  #     puts compares.sort_by { |k, v| v }.to_json
  #     puts "9999999999999999999999999999999        :::#{compares.keys.count}".yellow
  #     compared_item=nil
  #     if compared_item_arr= compares.sort_by { |k, v| v }.first
  #       compared_item=compared_item_arr[0]
  #       compared_item.update_attributes(optimise_index: current_index, state: ProductionOrderItemState::OPTIMISE_SUCCEED)
  #       current_index+=1
  #     end
  #     # compares.sort_by { |k, v| v }.flatten.select { |i| i.is_a?(ProductionOrderItem) }.each do |item|
  #     #   item.update_attributes(optimise_index: current_index,
  #     #                          state: ProductionOrderItemState::OPTIMISE_SUCCEED)
  #     #   current_index+=1
  #     # end
  #   end
  #   return current_index, compared_item
  # end


end
