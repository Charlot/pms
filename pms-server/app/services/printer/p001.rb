# Print KANBAN
module Printer
  class P001<Base
    HEAD=[:kanban_nr,:part_nr,:customer_nr,:wire_position,:card_number,:card_quantity,:print_date,:remark1,:remark2]

    BODY=[:route_nr,:route_name,:route_desc,:wire_nr1_of_route,:wire_nr2_of_route,:wire_nr3_of_route,
    :wiredesc1_of_route,:wiredesc2_of_route,:wiredesc3_of_route,
    :wire_quantity1_of_route,:wire_quantity2_of_route,:wire_quantity3_of_route,
    :unit_of_wire1,:unit_of_wire2,:unit_of_wire3,
    :work_time_of_route,:consume_date]

    def generate_data
      head={
          kanban_nr:self.id,
          part_nr:'part nr',
          print_date:Time.now,
          customer_nr:'customer nr',
          wire_position:'01 02 04',
          card_number:3,
          card_quantity:100,
          remark1:'remark1',
          remark2:'remark2'
      }

      heads = []
      HEAD.each do |k|
        heads<<{Key:k,Value:head[k]}
      end

      #Route Info
      1.times{
        bodies =[]
        body = {
            route_nr:'route nr',
            route_name:'route name',
            route_desc:'route desc',
            wire_nr1_of_route:'wire nr 1',
            wiredesc1_of_route:'wire desc 1',
            wire_quantity1_of_route:'wire quantity 1',
            unit_of_wire1:'unit of wire 1',
            wire_nr2_of_route:'wire nr 2',
            wiredesc2_of_route:'wire desc 2',
            wire_quantity2_of_route:'wire quantity 2',
            unit_of_wire2:'unit of wire 2',
            wire_nr3_of_route:'wire nr 3',
            wiredesc3_of_route:'wire desc 3',
            wire_quantity3_of_route:'wire quantity 3',
            unit_of_wire3:'unit of wire 3',
            work_time_of_route:'work time of route',
            consume_date:'consume date'
        }

        BODY.each do |k|
          bodies<<{Key:k,Value:body[k]}
        end

        self.data_set<<(heads+bodies)
        #end Route info
      }
    end
  end
end
