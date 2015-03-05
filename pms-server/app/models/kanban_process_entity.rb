class KanbanProcessEntity < ActiveRecord::Base
  validates_uniqueness_of :kanban_id, scope: :process_entity_id

  belongs_to :kanban, dependent: :destroy
  belongs_to :process_entity, dependent: :destroy

  # after_create :create_part_bom
  # after_destroy :destroy_part_bom
  # after_update :update_part_bom


  # private
  # def create_part_bom
  #   kb=self.kanban
  #   part=kb.part
  #
  # end
end
