class ProductionOrderItem < ActiveRecord::Base
  include AutoKey
  belongs_to :kanban
  belongs_to :production_order
  belongs_to :machine
  has_many :production_order_item_labels
  after_update :update_qty_to_terminate, if: :auto?
  after_update :generate_production_item_label, if: :auto?
  before_update :set_terminated
  after_update :move_stock

  after_update :generate_production_item_not_auto_label, :if => :not_auto?

  self.inheritance_column = :_type_disabled
  default_scope { where(type: ProductionOrderItemType::WHITE) }
  # after_update :enter_store
  # after_update :move_store
  #has_paper_trail

  def not_auto?
    !self.auto
  end

  def self.for_optimise
    joins(:kanban).where(kanbans: {ktype: KanbanType::WHITE}, state: ProductionOrderItemState.optimise_states).order(created_at: :desc)
  end

  def self.for_distribute(production_order=nil)
    #  puts "~~~~~~~~~~~~~~~~~~~~~#{production_order.to_json}"
    q=where(state: ProductionOrderItemState.distribute_states)
    q=q.where(production_order_id: production_order.id) unless production_order.nil?
    q
  end

  def self.first_wait_produce(machine)
    where(state: ProductionOrderItemState.wait_produce_states, machine_id: machine.id).joins(:kanban)
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
        .order(updated_at: :desc, production_order_id: :desc, optimise_index: :desc)
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
    unless self.production_order_item_labels.where(bundle_no: bundle).first
      qty=0
      if (bundle*self.kanban_bundle)<=self.kanban_qty
        qty=self.kanban_bundle
      else
        qty=self.kanban_qty-(bundle-1)*self.kanban_bundle
      end
      if qty>0
        position_nr=Warehouse::DEFAULT_POSITION
        whouse_nr=Warehouse::DEFAULT_WAREHOUSE
        if self.kanban
          position_nr= self.kanban.des_storage
          whouse_nr=Warehouse.get_whouse_by_position_prefix(self.kanban.des_storage)
        end

        self.production_order_item_labels.create(nr: "#{self.nr}-#{bundle.to_i.to_s}",
                                                 qty: qty,
                                                 bundle_no: bundle,
                                                 position_nr: position_nr,
                                                 whouse_nr: whouse_nr)
      end
    end
  end

  def generate_production_item_not_auto_label
    bundle=1
    unless self.production_order_item_labels.where(bundle_no: bundle).first
      qty=self.produced_qty
      position_nr=Warehouse::DEFAULT_POSITION
      whouse_nr=Warehouse::DEFAULT_WAREHOUSE
      if self.kanban
        position_nr= self.kanban.des_storage
        whouse_nr=Warehouse.get_whouse_by_position_prefix(self.kanban.des_storage)
      end

      self.production_order_item_labels.create(nr: "#{self.nr}-#{bundle.to_i.to_s}",
                                               qty: qty,
                                               bundle_no: bundle,
                                               position_nr: position_nr,
                                               whouse_nr: whouse_nr)
    end if self.auto==false
  end

  def update_qty_to_terminate
    if self.produced_qty_changed?
      unless self.state==ProductionOrderItemState::TERMINATED
        if self.produced_qty>=self.kanban_qty
          self.update(state: ProductionOrderItemState::TERMINATED)
        end
      end
    end if self.type==ProductionOrderItemType::WHITE
  end


  def generate_production_item_label
    if self.produced_qty_changed?
      position_nr=Warehouse::DEFAULT_POSITION
      whouse_nr=Warehouse::DEFAULT_WAREHOUSE
      if self.kanban
        position_nr= self.kanban.des_storage
        whouse_nr=Warehouse.get_whouse_by_position_prefix(self.kanban.des_storage)
      end

      if self.produced_qty>0
        if self.produced_qty % self.kanban_bundle==0
          bundle=self.produced_qty / self.kanban_bundle
          unless self.production_order_item_labels.where(bundle_no: bundle).first
            self.production_order_item_labels.create(nr: "#{self.nr}-#{bundle.to_i.to_s}",
                                                     qty: self.kanban.bundle,
                                                     bundle_no: bundle,
                                                     position_nr: position_nr,
                                                     whouse_nr: whouse_nr)
          end
        elsif (self.state==ProductionOrderItemState::TERMINATED && self.produced_qty>=self.kanban_qty)
          bundle=self.produced_qty / self.kanban_bundle+1
          qty=self.produced_qty-(bundle-1)*self.kanban_bundle
          self.production_order_item_labels.create(nr: "#{self.nr}-#{bundle.to_i.to_s}",
                                                   qty: qty,
                                                   bundle_no: bundle,
                                                   position_nr: position_nr,
                                                   whouse_nr: whouse_nr)
        end
      end
    end if self.type==ProductionOrderItemType::WHITE
  end

  def set_terminated
    if self.state_changed? && self.state==ProductionOrderItemState::TERMINATED
      if self.type==ProductionOrderItemType::WHITE
        self.terminated_at= Time.now
      end
      if self.kanban
        self.produced_qty=self.kanban.quantity
      end
    end

    if self.state_changed? && self.state==ProductionOrderItemState::MANUAL_TERMINATED
      if self.type==ProductionOrderItemType::WHITE
        self.terminated_at= Time.now
      end
    end


  end

  def move_stock
    if self.state_changed? && self.state==ProductionOrderItemState::TERMINATED
      ItemMoveStockWorker.perform_async(self.id)
    end if self.type==ProductionOrderItemType::WHITE

    if self.state_changed? && self.state==ProductionOrderItemState::MANUAL_TERMINATED
      ItemMoveStockWorker.perform_async(self.id)
    end if self.type==ProductionOrderItemType::WHITE
  end

  def can_move?
    [ProductionOrderItemState::INIT, ProductionOrderItemState::DISTRIBUTE_SUCCEED].include?(self.state)
  end

  def can_change_state?
    [ProductionOrderItemState::INIT,
     ProductionOrderItemState::OPTIMISE_FAIL,
     ProductionOrderItemState::OPTIMISE_SUCCEED,
     ProductionOrderItemState::OPTIMISE_CANCELED,
     ProductionOrderItemState::DISTRIBUTE_SUCCEED,
     ProductionOrderItemState::DISTRIBUTE_FAIL,
     ProductionOrderItemState::MANUAL_ABORTED].include?(self.state)
  end


  def self.can_change_kanban_qty_states
    [ProductionOrderItemState::INIT,
     ProductionOrderItemState::OPTIMISE_FAIL,
     ProductionOrderItemState::OPTIMISE_SUCCEED,
     ProductionOrderItemState::OPTIMISE_CANCELED,
     ProductionOrderItemState::DISTRIBUTE_SUCCEED,
     ProductionOrderItemState::DISTRIBUTE_FAIL]
  end

  def can_change_kanban_qty?
    ProductionOrderItem.can_change_kanban_qty_states.include?(self.state)
  end

  def kanban_nr
    @kanban_nr||=self.kanban.nr
  end


  def process_entity
    @process_entity ||= (self.kanban.process_entities.first)
  end

  def wire
    @wire||=process_entity.value_wire_nr.to_i
  end

  def wire_length
    @wire_length||=process_entity.value_wire_qty_factor.to_f
  end

  def t1
    @t1||=process_entity.value_t1.to_i
  end

  def t2
    @t2||=process_entity.value_t2.to_i
  end

  def s1
    @s1||=process_entity.value_s1.to_i
  end

  def s2
    @s2||=process_entity.value_s2.to_i
  end
end
