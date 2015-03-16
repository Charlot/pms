class ProductionOrderItem < ActiveRecord::Base
  include AutoKey
  belongs_to :kanban
  belongs_to :production_order
  belongs_to :machine

  def self.for_optimise
    joins(:kanban).where(kanbans: {ktype: KanbanType::WHITE}, state: ProductionOrderItemState.optimise_states)
  end

  def self.for_distribute(production_order=nil)
  #  puts "~~~~~~~~~~~~~~~~~~~~~#{production_order.to_json}"
    q=where(state: ProductionOrderItemState.distribute_states)
    q=q.where(production_order_id: production_order.id) unless production_order.nil?
    q
  end

  def self.optimise
    ProductionOrderItem.transaction do
      optimise_at=Time.now
      items=for_optimise
      if items.count>0
        order= ProductionOrder.new
        combinations=MachineCombination.load_combinations
        items.each do |item|
          if node= combinations.match(MachineCombination.init_node_by_kanban(item.kanban))
            item.update(machine_id: node.machine_id,
                        optimise_index: Machine.find_by_id(node.machine_id).optimise_time_by_kanban(item.kanban),
                        optimise_at: optimise_at,
                        state: ProductionOrderItemState::OPTIMISE_SUCCEED)
            order.production_order_items<<item
          else
            item.update(state: ProductionOrderItemState::OPTIMISE_FAIL)
          end
        end
        order.save
        return order
      end
    end
  end
end
