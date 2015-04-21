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
    def generate_data(args=nil)
      @kanban = Kanban.find_by_nr(self.id)
      @kanban.update(print_time:Time.now)
      #TODO还要加一个条形码字段，条形码中不只是KANBAN NR
      head={
          kanban_nr: @kanban.nr,
          part_nr: @kanban.product_nr,
          print_date:@kanban.print_time,
          customer_nr:@kanban.product_custom_nr,
          wire_position:@kanban.desc_position,
          card_number:@kanban.copies,
          card_quantity:@kanban.quantity,
          kanban_2dcode:@kanban.printed_2DCode,
          #TODO kanban remark
          remark1:@kanban.remark,
          remark2:@kanban.gathered_material+"      "+@kanban.remark2
      }

      heads = []
      HEAD.each do |k|
        heads<<{Key:k,Value:head[k]}
      end

      @kanban.kanban_process_entities.order(order: :asc).each do |kpe|
        pe = kpe.process_entity
        bodies =[]
        body = {
            route_nr:pe.process_template.code,
            route_name:pe.name,
            route_desc:pe.template_text,
            work_time_of_route:pe.stand_time,
            consume_date: kpe.id#TODO route consume data
        }

        pe.process_parts.first($ROUTE_PART_COUNT).each_with_index { |pp,index |
          if pe.value_default_wire_nr.nil? || pe.value_default_wire_nr != pp.part.nr
            if pp.part.type == PartType::PRODUCT_SEMIFINISHED && pp.part.nr.include?("_")
              body["wire_nr#{index+1}_of_route".to_sym] = pp.part.nr.split("_").last
            else
              body["wire_nr#{index+1}_of_route".to_sym] = pp.part.nr
            end
            body["wiredesc#{index+1}_of_route".to_sym] = pp.part.custom_nr
            body["wire_quantity#{index+1}_of_route".to_sym] = pp.quantity
            body["unit_of_wire#{index+1}".to_sym] = pp.unit
          end
        }

        BODY.each do |k|
          bodies<<{Key:k,Value:body[k]}
        end

        self.data_set<<(heads+bodies)
      end
    end
  end
end
