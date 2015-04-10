# Print BUNDLE LABEL
module Printer
  class P003<Base
    HEAD=[:CO_Nr, :CP_Nr,
          :kBanNr, :warehouse,
          :pnNr, :bundleNo, :totalQuantity, :bQuantity, :singleResCC, :wireNr,
          :partNr, :partDesc, :color, :length, :diameter,
          :t1_nr, :t1_custom_nr, :t1_strip_length, :s1_nr,
          :t2_nr, :t2_custom_nr, :t2_strip_length, :s2_nr,
          :bundleLabelNr]

    def generate_data(args=nil)
      kanban = Kanban.find_by_id(self.id)
      #Now the Automatic KANBAN onlu has 1 process entity
      process_entity = kanban.process_entities.first
      wire=Part.find_by_id(process_entity.value_wire_nr)

      head={
          CO_Nr: 'CO_NR',
          CP_Nr: 'CP_NR',
          kBanNr: kanban.nr,
          warehouse: kanban.des_storage,
          pnNr: 'pnNr',
          bundleNo: args[:bundle_no],
          totalQuantity: kanban.quantity,
          bQuantity: kanban.bundle,
          singleResCC: args[:machine_nr],
          wireNr: kanban.wire_nr,
          partNr: wire.nr,
          partDesc: wire.description||'',
          color: 'color',
          length: process_entity.value_wire_qty_factor,
          diameter: wire.cross_section,
          t1_nr: '', t1_custom_nr: '', t1_strip_length: '', s1_nr: '',
          t2_nr: '', t2_custom_nr: '', t2_strip_length: '', s2_nr: '',
          bundleLabelNr: SecureRandom.uuid
      }

      %w(t1 t2 s1 s2).each { |cf|
        value = process_entity.send("value_#{cf}")
        if value && part = Part.find_by_id(value)
          head["#{cf}_custom_nr".to_sym] = part.custom_nr if head.has_key?("#{cf}_custom_nr".to_sym)
          head["#{cf}_nr".to_sym] = part.nr if head.has_key?("#{cf}_nr".to_sym)
          head["#{cf}_strip_length".to_sym]=process_entity.send("#{cf}_strip_length") if head.has_key?("#{cf}_strip_length".to_sym)
        end
      }

      heads=[]
      HEAD.each do |k|
        heads<<{Key: k, Value: head[k]}
      end

      self.data_set<<heads
    end
  end
end
