class ProductionOrderItemModel
  include ActiveModel::Model

  attr_accessor :id, :nr, :kanban_nr, :wire, :wire_length, :t1, :t2, :s1, :s2, :order_item, :optimized

  def self.initialize_items(order_items, macine)
    return nil if order_items.length==0

    items=[]

    sorted_items=[]

    order_items.each do |item|
      items<<self.new(id: item.id,
                      nr: item.nr,
                      kanban_nr: item.kanban_nr,
                      wire: item.wire, wire_length: item.wire_length,
                      t1: item.t1, t2: item.t2, s1: item.s1, s2: item.s2,
                      order_item: item, optimized: false)
    end

    items.each do |item|
     
    end
    # select all the same
  end

  def self.fake_initialize_items(order_items, machine)
    items=[]
    sorted_items=[]

    order_items.each do |item|
      #t1, t2=item.t1 <item.t2 ? [item.t1, item.t2] : [item.t2, item.t1]
      #s1, s2=item.s1 <item.s2 ? [item.s1, item.s2] : [item.s2, item.s1]
      #items<<self.new(id: item.id, wire_nr: item.wire_nr, t1: t1, t2: t2, s1: s1, s2: s2, order_item: item)
      # raise if (item.t1=='' || item.t2=='')
      items<<self.new(id: item.id,
                      nr: item.nr,
                      kanban_nr: item.kanban_nr,
                      wire: item.wire, wire_length: item.wire_length,
                      t1: item.t1, t2: item.t2, s1: item.s1, s2: item.s2,
                      order_item: item)
    end


    items.each_with_index do |item, i|
      puts "**i.#{i}...------------------------ "

      if sorted_items.length==0
        puts "first one: #{i}---------------#{item.nr}--#{item.kanban_nr}******first one".blue
        sorted_items<<item
      else
        puts "------------------------length: #{sorted_items.length}".yellow
        for j in 0...sorted_items.length do
          puts "j.#{j}...length: #{sorted_items.length}------------------------ "
          first_compare_time=compare_item(item, sorted_items[j], machine)
          if j<sorted_items.length-1
            second_compare_time=compare_item(item, sorted_items[j+1], machine)
            if first_compare_time<second_compare_time
              puts "lt:#{i}----------got it---#{j}-#{sorted_items[j].kanban_nr}:#{first_compare_time}--vs--#{j+1}:#{sorted_items[j+1].kanban_nr}::#{second_compare_time}----insert_at: #{j+1}----#{item.nr}---#{item.kanban_nr}".blue
              sorted_items.insert(j+1, item)
              break
            elsif (first_compare_time==second_compare_time) && (first_compare_time==0)
              puts "eq:#{i}----------got it---#{j}-#{sorted_items[j].kanban_nr}:#{first_compare_time}--vs--#{j+1}:#{sorted_items[j+1].kanban_nr}::#{second_compare_time}----insert_at: #{j+2}----#{item.nr}---#{item.kanban_nr}".blue
              sorted_items.insert(j+2, item)
              break
            else
              next
            end
          else
            puts "#{j}...----------oh, last one---#{j}--#{sorted_items[j].kanban_nr}}::--#{first_compare_time}----#{item.nr}---#{item.kanban_nr}".red

            sorted_items<<item
          end
        end

        puts '************************************************'.green
        # sorted_items.each { |item| puts item.to_json }
        puts '************************************************'.green
      end
    end
    sorted_items
  end

  def self.compare_item(item, compare_item, machine)
    weight=0

    # compare wire
    unless item.wire==compare_item.wire
      weight+=machine.wire_time
    end

    # compare with length
    unless item.wire_length==compare_item.wire_length
      weight+=machine.wire_length_time
    end

    # compare t1 && t2

    t1=item.t1
    t2=item.t2
    ct1=compare_item.t1
    ct2=compare_item.t2
    # a,b vs a,b
    # a,b can be any value
    if t1==ct1 && t2==ct2
      weight+=0
      puts 'step 1...............................'
      # a,b vs b,a
      # a,b can be any value
    elsif t1==ct2 && t2==ct1
      weight+=0
      puts 'step 2...............................'
    else
      # a,b vs b,nil/nil,b
      # a,b vs a,nii/nil,a
      # a,b vs nil,nil
      # a,b not nil
      if ct1.nil? && ct2.nil?
        weight+=0
      elsif (![t1, t2].include?(nil)) && [ct1, ct2].include?(nil) && [t1, t2].include?([ct1, ct2].select { |i| i }[0])
        weight+=0
        puts 'step 3...............................'
      else
        if (t1!=ct1 && t2!=ct2) && (t1!=ct1 && t2!=ct1)
          weight+= machine.terminal_time*2
          puts 'step 4...............................'
        else
          if t1==ct1 || t2==ct2 || t1==ct2 || t2==ct1
            weight+= machine.terminal_time
            puts 'step 5...............................'
          end
        end
      end
    end

    #
    # # compare s1 && s2
    # s1=item.s1
    # s2=item.s2
    # cs1=compare_item.s1
    # cs2=compare_item.s2
    # # a,b vs a,b
    # # a,b can be any value
    # if s1==cs1 && s2==cs2
    #   weight+=0
    #   # a,b vs b,a
    #   # a,b can be any value
    # elsif s1==cs2 && s2==cs1
    #   weight+=0
    # else
    #   # a,b vs b,nil/nil,b
    #   # a,b vs a,nii/nil,a
    #   # a,b vs nil,nil
    #   # a,b not nil
    #   if (![s1, s2].include?(nil)) && [cs1, cs2].include?(nil) && [s1, s2].include?([cs1, cs2].select { |i| i }[0])
    #     weight+=0
    #   else
    #     if (s1!=cs1 && s2!=cs2) && (s1!=cs1 && s2!=cs1)
    #       weight+= machine.seal_time*2
    #     else
    #       if s1==cs1 || s2==cs2 || s1==cs2 || s2==cs1
    #         weight+= machine.seal_time
    #       end
    #     end
    #   end
    # end

    weight
  end


end