# Print BAI KANBAN
module Printer
  class P002<Base
    HEAD=[:kanban_nr,:part_nr,:wire_nr,:customer_nr,:card_quantity,:safe_quantity,:card_number,:work_time,:send_position,
    :wire_description,:wire_length,:bundle_number,:strip_length1,:terminal_custom_nr1,:terminal_nr1,:seal_custom_nr1,:seal_nr1,
                                                        :strip_length2,:terminal_custom_nr2,:terminal_nr2,:seal_custom_nr2,:seal_nr2,
          :apab_description,:remark]

    def generate_data
      head={
          kanban_nr:self.id,
          part_nr:'91G0001',
          wire_nr:'wire_3456',
          customer_nr:'CN0001',
          card_quantity:200,
          safe_quantity:100,
          card_number:2,
          work_time:78.98,
          send_position:'POSITION01',
          wire_description:'this is a heartbroke time',
          wire_length:100,
          bundle_number:50,
          strip_length1:3.5,
          terminal_custom_nr1:'ct001',
          terminal_nr1:'t001',
          seal_custom_nr1:'cs001',
          seal_nr1:'s001',
          strip_length2:4,
          terminal_custom_nr2:'ct002',
          terminal_nr2:'t002',
          seal_custom_nr2:'cs002',
          seal_nr2:'s002',
          apab_description:'i really donnot known',
          remark:'time...time...time'
      }
      heads=[]
      HEAD.each do |k|
        heads<<{Key:k,value:head[k]}
      end



      self.data_set<<heads
    end
  end
end