module PartBomable
  extend ActiveSupport::Concern

  included do
    after_create :create_part_bom
    after_update :update_part_bom
  end

  def update_part_bom
    if self.is_a?(ProcessEntity)
      self.kanbans.each do |kanban|

      end
    end
  end

  def create_part_bom
    if self.is_a?(Kanban)

    end
  end

  def kanban_part_nr
    if self.is_a?(Kanban)
      @kanban_part_nr||= (self.full_wire_nr || ("#{Part.find_by_id(self.product_id).nr}_#{ProcessEntity.find_by_id(self.process_entities.first.id).nr}"))
    else
      @kanban_part_nr||=nil
    end
  end

  def kanban_part
    if self.is_a?(Kanban)
      @kanban_part||= Part.find_by_nr(@kanban_part_nr||kanban_part_nr)
    else
      @kanban_part||=nil
    end
  end

  def generate_part_bom
    if self.is_a?(Kanban)
      part=if self.kanban_part
             self.kanban_part
           else
             Part.create(type: PartType::PRODUCT_SEMIFINISHED, remark: '创建BOM时系统自动生成', nr: self.kanban_part_nr)
           end


    end
  end
end