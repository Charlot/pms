# Print BAI KANBAN
module Printer
  class P002<Base
    HEAD=[:kanban_nr,:part_nr,:wire_nr,:customer_nr,:card_quantity,:safe_quantity,:card_number,:work_time,:send_position,
    :wire_description,:wire_length,:bundle_number,:strip_length1,:terminal_custom_nr1,:terminal_nr1,:seal_custom_nr1,:seal_nr1,
                                                        :strip_length2,:terminal_custom_nr2,:terminal_nr2,:seal_custom_nr2,:seal_nr2,
          :apab_description,:remark,:kanban_2dcode]

    def generate_data
      @kanban = Kanban.find_by_id(self.id)
      #Now the Automatic KANBAN onlu has 1 process entity
      @process_entity = @kanban.process_entities.first

      parts_info = {}

      ['t1','t2','s1','s2'].each{|cf|
        value = @process_entity.send("value_#{cf}")
        if value && part = Part.find_by_id(value)
          parts_info["#{cf}_custom_nr".to_sym] = part.custom_nr
          parts_info["#{cf}_nr".to_sym] = part.nr
        else
          parts_info["#{cf}_custom_nr".to_sym]= nil
          parts_info["#{cf}_nr".to_sym] = nil
        end
      }
      #应该是固定的，消耗的原材料，填入
      head={
          kanban_nr:@kanban.nr,
          part_nr:@kanban.product_nr,
          wire_nr:@kanban.part_nr,
          customer_nr: @kanban.product_custom_nr,
          card_quantity:@kanban.quantity,
          safe_quantity:@kanban.safety_stock,
          card_number:@kanban.copies,
          work_time:@kanban.task_time,
          send_position:@kanban.source_position,
          wire_description:@kanban.part_custom_nr,
          kanban_2dcode: @kanban.printed_2DCode,

          wire_length:@kanban.wire_length,
          bundle_number:@kanban.bundle,

          strip_length1:@process_entity.t1_strip_length,
          terminal_custom_nr1:parts_info[:t1_custom_nr],
          terminal_nr1: parts_info[:t1_nr],

          seal_custom_nr1:parts_info[:s1_custom_nr],
          seal_nr1:parts_info[:s1_nr],

          strip_length2:@process_entity.t2_strip_length,
          terminal_custom_nr2:parts_info[:t2_custom_nr],
          terminal_nr2:parts_info[:t2_nr],

          seal_custom_nr2:parts_info[:s2_custom_nr],
          seal_nr2:parts_info[:s2_nr],

          apab_description:'i really donnot known',
          remark:@kanban.remark
      }
      heads=[]
      HEAD.each do |k|
        heads<<{Key:k,Value:head[k]}
      end

      self.data_set<<heads

    end
  end
end
