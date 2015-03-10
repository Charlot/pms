# Print KANBAN
module Printer
  class P001<Base
    HEAD=[:kanban_nr,:part_nr,:customer_nr,:wire_position,:card_number,:card_quantity,:print_date,:remark1,:remark2,:kanban_2dcode]
    BODY=[:route_nr,:route_name,:route_desc,:work_time_of_route,:consume_date]

    $ROUTE_PART_COUNT.times {|i|
      BODY<<"wire_nr#{i+1}_of_route".to_sym
      BODY<<"wiredesc#{i+1}_of_route".to_sym
      BODY<<"wire_quantity#{i+1}_of_route".to_sym
      BODY<<"unit_of_wire#{i+1}".to_sym
    }

    #注意，与KANBAN模板一直，一个Routing中最多包含的parts只能有5种
    def generate_data
      @kanban = Kanban.find_by_id(self.id)
      @kanban.update(print_time:Time.now)
      #TODO还要加一个条形码字段，条形码中不只是KANBAN NR
      head={
          kanban_nr: @kanban.nr,
          part_nr: @kanban.part_nr,
          print_date:@kanban.print_time,
          customer_nr:@kanban.part_custom_nr,
          wire_position:@kanban.desc_position,
          card_number:@kanban.copies,
          card_quantity:@kanban.quantity,
          kanban_2dcode:@kanban.printed_2DCode,
          #TODO kanban remark
          remark1:'remark1',
          remark2:'remark2'
      }

      heads = []
      HEAD.each do |k|
        heads<<{Key:k,Value:head[k]}
      end

      @kanban.process_entities.each do |pe|
        bodies =[]
        body = {
            route_nr:pe.nr,
            route_name:pe.name,
            route_desc:pe.description,
            work_time_of_route:pe.stand_time,
            #Consume Date是什么东西？
            consume_date:'consume date'
        }

        pe.process_parts.first($ROUTE_PART_COUNT).each_with_index { |pp,index |
          body["wire_nr#{index+1}_of_route".to_sym] = pp.part.nr
          body["wiredesc#{index+1}_of_route".to_sym] = pp.part.custom_nr
          body["wire_quantity#{index+1}_of_route".to_sym] = pp.quantity
          body["unit_of_wire#{index+1}".to_sym] = pp.unit
        }

        BODY.each do |k|
          bodies<<{Key:k,Value:body[k]}
        end

        self.data_set<<(heads+bodies)
      end
    end
  end
end
