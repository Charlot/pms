# Print BAI KANBAN
module Printer
  class P002<Base
    HEAD=[:kanban_nr, :part_nr, :wire_nr, :customer_nr, :card_quantity, :safe_quantity, :card_number, :work_time, :send_position,
          :wire_description, :wire_length, :bundle_number, :strip_length1, :terminal_custom_nr1, :terminal_nr1, :seal_custom_nr1, :seal_nr1,
          :strip_length2, :terminal_custom_nr2, :terminal_nr2, :seal_custom_nr2, :seal_nr2,
          :apab_description, :remark, :machine_nr, :kanban_2dcode]

    def generate_data(args=nil)
      @kanban = Kanban.find_by_nr(self.id)
      #Now the Automatic KANBAN onlu has 1 process entity
      @process_entity = @kanban.process_entities.first
      parts_info = {}

      wire=Part.find_by_id(@process_entity.value_wire_nr)
      wire_desc= wire.nil? ? '' : "#{wire.nr}; #{wire.color}; #{wire.cross_section} ;#{wire.component_type};  #{wire.description}"
      ['t1', 't2', 's1', 's2'].each { |cf|
        value = @process_entity.send("value_#{cf}")
        if value && part = Part.find_by_id(value)
          parts_info["#{cf}_custom_nr".to_sym] = part.custom_nr
          parts_info["#{cf}_nr".to_sym] = part.nr
        else
          parts_info["#{cf}_custom_nr".to_sym]= ''
          parts_info["#{cf}_nr".to_sym] = ''
        end
      }

      #应该是固定的，消耗的原材料，填入
      head={
          kanban_nr: @kanban.nr,
          machine_nr: args[:machine_nr],
          part_nr: @kanban.product_nr,
          wire_nr: @kanban.wire_nr,
          customer_nr: @kanban.product_custom_nr,
          card_quantity: @kanban.quantity,
          safe_quantity: "", #@kanban.safety_stock.to_i,
          card_number: @kanban.copies,
          work_time: '',
          send_position: @kanban.des_storage,
          wire_description: wire_desc,

          kanban_2dcode: @kanban.printed_2DCode,
          wire_length: @process_entity.value_wire_qty_factor,
          bundle_number: @kanban.bundle,
          strip_length1: @process_entity.t1_strip_length,
          terminal_custom_nr1: parts_info[:t1_custom_nr],
          terminal_nr1: parts_info[:t1_nr],
          seal_custom_nr1: parts_info[:s1_custom_nr],
          seal_nr1: parts_info[:s1_nr],
          strip_length2: @process_entity.t2_strip_length,
          terminal_custom_nr2: parts_info[:t2_custom_nr],
          terminal_nr2: parts_info[:t2_nr],
          seal_custom_nr2: parts_info[:s2_custom_nr],
          seal_nr2: parts_info[:s2_nr],
          apab_description: @kanban.remark2,
          remark: @kanban.remark
      }
      heads=[]
      HEAD.each do |k|
        heads<<{Key: k, Value: head[k]}
      end

      self.data_set<<heads
      puts self.data_set.to_json.red
    end
  end
end
