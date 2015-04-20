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

  def self.first_wait_produce(machine)
    where(state: ProductionOrderItemState.wait_produce_states, machine_id: machine.id)
        .order(production_order_id: :asc, optimise_index: :asc).first
  end

  def self.for_produce(machine=nil)
    if machine
      where(state: ProductionOrderItemState.wait_produce_states, machine_id: machine.id)
          .order(production_order_id: :asc, optimise_index: :asc)
    else
      where(state: ProductionOrderItemState.wait_produce_states)
          .order(production_order_id: :asc, optimise_index: :asc)
    end
  end

  def self.for_passed(machine)
    where(state: ProductionOrderItemState.passed_states, machine_id: machine.id)
        .order(production_order_id: :desc, optimise_index: :desc)
  end

  def self.for_export(production_order)
    where(production_order_id: production_order.id)
        .joins(:kanban)
        .joins(:production_order)
        .joins(:machine).order(machine_id: :asc, production_order_id: :asc,optimise_index: :asc)
        .select('production_orders.nr as production_order_nr,kanbans.nr as kanban_nr,machines.nr as machine_nr,production_order_items.*')
  end

  def self.optimise
    ProductionOrderItem.transaction do
      optimise_at=Time.now
      items=for_optimise
      success_count=0
      if items.count>0
        order= ProductionOrder.new
        combinations=MachineCombination.load_combinations
        items.each do |item|
          if node= combinations.match(MachineCombination.init_node_by_kanban(item.kanban))

            # item.update(machine_id: node.machine_id,
            #             optimise_index: Machine.find_by_id(node.machine_id).optimise_time_by_kanban(item.kanban),
            #             optimise_at: optimise_at,
            #             state: ProductionOrderItemState::OPTIMISE_SUCCEED)
            #

            item.update(machine_id: node.machine_id,
                        machine_time: Machine.find_by_id(node.machine_id).optimise_time_by_kanban(item.kanban),
                        optimise_at: optimise_at
            )
            order.production_order_items<<item
            success_count+=1
          else
            item.update(state: ProductionOrderItemState::OPTIMISE_FAIL)
          end
        end
        self.optimise_order
        if success_count>0
          order.save
          return order
        end
      end
    end
  end

  def self.optimise_order
    Machine.all.each do |machine|
      machine.sort_order_item
    end
  end
end
