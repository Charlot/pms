class ProductionOrderItem < ActiveRecord::Base
  include AutoKey
  belongs_to :kanban
  belongs_to :production_order
  belongs_to :machine
  has_many :production_order_item_labels
  after_update :update_qty_to_terminate
  after_update :generate_production_item_label
  after_update :enter_store
  after_update :move_store
  has_paper_trail

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
      joins(:machine).where(state: ProductionOrderItemState.wait_produce_states)
          .order(production_order_id: :asc, optimise_index: :asc)
    end
  end

  def self.for_passed(machine)
    where(state: ProductionOrderItemState.passed_states, machine_id: machine.id)
        .order(updated_at: :desc,production_order_id: :desc, optimise_index: :desc)
  end

  def self.for_export(production_order)
    where(production_order_id: production_order.id)
        .joins(:kanban)
        .joins(:production_order)
        .joins(:machine).order(machine_id: :asc, production_order_id: :asc, optimise_index: :asc)
        .select('production_orders.nr as production_order_nr,kanbans.nr as kanban_nr,machines.nr as machine_nr,production_order_items.*')
  end

  def self.optimise
    # ProductionOrderItem.transaction do
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
          if machine=Machine.find_by_id(node.machine_id)
            item.update(machine_id: node.machine_id,
                        machine_time: machine.optimise_time_by_kanban(item.kanban),
                        optimise_at: optimise_at
            # , state: ProductionOrderItemState::OPTIMISE_SUCCEED
            )

            order.production_order_items<<item
            success_count+=1
          end
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
    # end
  end

  def self.optimise_order
    Machine.all.each do |machine|
      machine.sort_order_item
    end
  end


  def create_label bundle
    bundle=bundle.to_i
    if self.kanban
      unless self.production_order_item_labels.where(bundle_no: bundle).first
        qty=0
        if (bundle*self.kanban.bundle)<=self.kanban.quantity
          qty=self.kanban.bundle
        else
          qty=self.kanban.quantity-(bundle-1)*self.kanban.bundle
        end
        if qty>0
          self.production_order_item_labels.create(nr: "#{self.nr}-#{bundle}",
                                                   qty: qty,
                                                   bundle_no: bundle,
                                                   position_nr: self.kanban.des_storage,
                                                   whouse_nr: Warehouse.get_whouse_by_position_prefix(self.kanban.des_storage))
        end
      end
    end
  end

  def update_qty_to_terminate
    if self.produced_qty_changed?
      unless self.state==ProductionOrderItemState::TERMINATED
        if self.kanban && self.produced_qty>=kanban.quantity
          self.update(state: ProductionOrderItemState::TERMINATED)
        end
      end
    end
  end


  def generate_production_item_label
    if self.produced_qty_changed?
      if self.kanban && self.produced_qty>0
        if self.produced_qty % self.kanban.bundle==0
          bundle=self.produced_qty / self.kanban.bundle
          unless self.production_order_item_labels.where(bundle_no: bundle).first
            self.production_order_item_labels.create(nr: "#{self.nr}-#{bundle}",
                                                     qty: self.kanban.bundle,
                                                     bundle_no: bundle,
                                                     position_nr: self.kanban.des_storage,
                                                     whouse_nr: Warehouse.get_whouse_by_position_prefix(self.kanban.des_storage))
          end
        elsif (self.state==ProductionOrderItemState::TERMINATED && self.produced_qty>=self.kanban.quantity)
          bundle=self.produced_qty / self.kanban.bundle+1
          qty=self.produced_qty-(bundle-1)*self.kanban.bundle
          self.production_order_item_labels.create(nr: "#{self.nr}-#{bundle}",
                                                   qty: qty,
                                                   bundle_no: bundle,
                                                   position_nr: self.kanban.des_storage,
                                                   whouse_nr: Warehouse.get_whouse_by_position_prefix(self.kanban.des_storage))
        end
      end
    end
  end

  def enter_store

  end

  def move_store

  end

  def can_auto_store
    # if self.state_changed? &&
  end
end
