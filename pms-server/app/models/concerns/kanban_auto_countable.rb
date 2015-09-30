module KanbanAutoCountable
  extend ActiveSupport::Concern
  included do
    after_update :recount_auto_copy
  end

  def recount_auto_copy
    if self.is_a?(Kanban)
      if self.product_id_changed?
        count_kanban({product_id: [self.product_id, self.product_id_was],
                      process_entity_id: process_entity_id}) &update_rac_proc
      end

      if self.state_changed?
        count_kanban({product_id: self.product_id, process_entity_id: process_entity_id}) &update_rac_proc
      end
    end
  end

  private
  def count_kanban(options={})
    base_query= Kanban.joins(:kanban_process_entities)
                    .where(kanban_process_entities: {position: 0})
                    .where.not(kanbans: {state: KanbanState::DELETED})
                    .group(:product_id, :process_entity_id)
                    .select('count(*) as size,product_id,process_entity_id')

    if options[:product_id]
      base_query=base_query.where(product_id: options[:product_id])
    end

    if options[:process_entity_id]
      base_query=base_query.where(kanban_process_entities: {process_entity_id: options[:process_entity_id]})
    end
    yield(base_query) if block_given?
    base_query
  end

  def process_entity_id
    if self.is_a?(Kanban) && (pe=self.kanban_process_entities.first)
      pe.process_entity_id
    end
  end


  def update_rac_proc
   Proc.new { |query|
      query.each_with_index { |item, i|
        update_recount_auto_copy(item.product_id, item.process_entity_id, item.size)
      }
    }
  end

  def update_recount_auto_copy(product_id, process_entity_id, size)
    Kanban.joins(:kanban_process_entities).where(product_id: product_id,
                                                 kanban_process_entities: {position: 0, process_entity_id: process_entity_id})
        .update_all(auto_copy_count: size)
  end
end