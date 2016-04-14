# Print BLUE KANBAN
module Printer
  class P001<Base
    ROUTE_PART_COUNT=5
    HEAD=[:kanban_nr, :part_nr, :customer_nr, :wire_position, :card_number, :card_quantity, :print_date, :remark1, :remark2, :kanban_2dcode]
    # BODY=[:route_nr, :route_name, :route_desc, :route_part_info, :work_time_of_route, :consume_date, :route_remark]
    BODY=[:route_nr, :route_name, :route_desc, :route_part_info, :work_time_of_route, :consume_date, :route_remark]

    ROUTE_PART_COUNT.times { |i|
      BODY<<"wire_nr#{i+1}_of_route".to_sym
      BODY<<"wiredesc#{i+1}_of_route".to_sym
      BODY<<"wire_quantity#{i+1}_of_route".to_sym
      BODY<<"unit_of_wire#{i+1}".to_sym
    }

    #注意，与KANBAN模板一直，一个Routing中最多包含的parts只能有5种
    def generate_data(args=nil)
      @kanban = Kanban.find_by_nr(self.id)
      @kanban.without_versioning do
        @kanban.update(print_time: Time.now)
      end
      #TODO还要加一个条形码字段，条形码中不只是KANBAN NR
      head={
          kanban_nr: @kanban.nr,
          part_nr: @kanban.product_nr,
          print_date: @kanban.print_time,
          customer_nr: @kanban.product_custom_nr,
          wire_position: @kanban.desc_position,
          card_number: @kanban.auto_copy_count,
          card_quantity: @kanban.quantity,
          kanban_2dcode: @kanban.printed_2DCode,
          #TODO kanban remark
          remark1: @kanban.remark,
          remark2: @kanban.gathered_material+"      "+@kanban.remark2
      }

      heads = []
      HEAD.each do |k|
        heads<<{Key: k, Value: head[k]}
      end

      @kanban.kanban_process_entities.each do |kpe|
        pe = kpe.process_entity
        bodies =[]
        body = {
            route_nr: pe.process_template.code,
            route_name: pe.name.to_i.to_s,
            route_desc: pe.template_text,
            work_time_of_route: (pe.work_time * @kanban.quantity).round(3),
            route_remark: pe.remark,
            route_part_info: '',
            consume_date: pe.nr #TODO route consume data
        }

        route_part_info=''
        total=0


        # route_part_info.sub!(/TOTAL/, total.to_s)
        body[:route_part_info]=Printer::Extend::ProcessTemplate2410.process_route_part_info_text(pe) if pe.process_template.code=='2410'

        ii=0
        pe.process_parts.joins(:part).order('parts.type').where.not(part_id: nil).each_with_index { |pp, index|
          if pe.value_default_wire_nr.nil? || pe.value_default_wire_nr != pp.part.id.to_s
            if pp.part.type == PartType::PRODUCT_SEMIFINISHED #&& pp.part.nr.include?("_")
              body["wire_nr#{index+1}_of_route".to_sym] = pp.part.nr_nick_name #.split("_").last
              puts "################{pp.part.nr}".red
            else
              body["wire_nr#{index+1}_of_route".to_sym] = pp.part.nr
            end
            body["wiredesc#{index+1}_of_route".to_sym] = "#{pp.part.custom_nr}#{pp.part.tool_nrs.blank? ? nil : '('+pp.part.tool_nrs+')'}"
            body["wire_quantity#{index+1}_of_route".to_sym] = pp.quantity
            body["unit_of_wire#{index+1}".to_sym] = pp.part.unit
            ii+=1
          end if pp.part && ii<ROUTE_PART_COUNT
        }

        BODY.each do |k|
          bodies<<{Key: k, Value: body[k]}
        end

        self.data_set<<(heads+bodies)
      end
    end
  end
end