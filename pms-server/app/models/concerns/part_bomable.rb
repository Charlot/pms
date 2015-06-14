module PartBomable
  extend ActiveSupport::Concern

  included do
    after_create :create_part_bom
    after_update :update_part_bom
  end

  def update_part_bom
    if self.is_a?(ProcessEntity)
      self.kanbans.each do |kanban|
        kanban.update_bom_by_process_entity(self)
      end
    end
  end

  def create_part_bom
    if self.is_a?(Kanban)

    end
  end

  def part_nr
    if self.is_a?(Kanban)
      @part_nr||=("#{Part.find_by_id(self.product_id).nr}_#{ProcessEntity.find_by_id(self.process_entities.first.id).nr}")
    else
      @part_nr||=nil
    end
  end

  def part
    if self.is_a?(Kanban)
      @part= Part.find_by_nr(@virtual_part_nr)
    else
      @part||=nil
    end
  end

  def update_bom_by_process_entity(process_entity)

  end
end