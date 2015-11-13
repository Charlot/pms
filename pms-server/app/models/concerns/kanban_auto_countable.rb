module KanbanAutoCountable
  extend ActiveSupport::Concern
  included do
    after_save :save_recount_auto_copy
	after_destroy :destroy_recount_auto_copy
  end

  def save_recount_auto_copy
	  if self.is_a?(Kanban)
		  #if self.prddoduct_id_changed?
		  #count_kanban({product_id: [self.product_id, self.product_id_was],
		  #process_entity_id: process_entity_id},update_rac_proc)
		  #end
		  state_change_call
	  elsif self.is_a?(KanbanProcessEntity)
		  state_change_call if self.position==0
	  end
  end


  def destroy_recount_auto_copy
    if self.is_a?(Kanban)
	  save_recount_auto_copy
	elsif self.is_a?(KanbanProcessEntity)
		state_change_call if self.position==0
	end
  end

  private

  def state_change_call
	  if self.state_changed?
		  options={product_id: ac_product_id, process_entity_id: ac_process_entity_id}
		  if base_query_kanban(options).count.first.nil? 
			  update_recount_auto_copy(ac_product_id,ac_process_entity_id,0)
		  else
			  query_kanban(options,update_rac_proc)
		  end
	  end
  end

  
  def base_query_kanban options={}
    q= Kanban.joins(:kanban_process_entities)
                    .where(kanban_process_entities: {position: 0})
                    .where.not(kanbans: {state: KanbanState::DELETED})
                    .group(:product_id, :process_entity_id)


    if options[:product_id]
      q=q.where(product_id: options[:product_id])
    end

    if options[:process_entity_id]
      q=q.where(kanban_process_entities: {process_entity_id: options[:process_entity_id]})
    end
	q
  end

  def query_kanban(options,block)
    q=base_query_kanban(options).select('count(*) as size,product_id,process_entity_id')

    yield(q) if block_given?
	if block
		block.call(q)
	end
    q
  end

  def ac_process_entity_id
    if self.is_a?(Kanban) && (pe=self.kanban_process_entities.first)
      pe.process_entity_id
	elsif self.is_a?(KanbanProcessEntity)
		self.process_entity_id
    end
  end

  def ac_product_id
	  if self.is_a?(Kanban)
		  self.product_id
	  elsif self.is_a?(KanbanProcessEntity)
		  kanban.product_id	  if (kanban=self.kanban)
	  end
  end

  def update_rac_proc
   Proc.new { |query|
      query.each_with_index { |item, i|
        update_recount_auto_copy(item[:product_id], item[:process_entity_id], item[:size])
	  }
    }
  end

  def update_recount_auto_copy(product_id, process_entity_id, size)
    Kanban.joins(:kanban_process_entities).where(product_id: product_id,
                                                 kanban_process_entities: {position: 0, process_entity_id: process_entity_id})
        .update_all(auto_copy_count: size)
  end
end
