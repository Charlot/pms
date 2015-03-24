class ProductionOrderItemPresenter<Presenter
  Delegators=[:id, :nr, :production_order, :production_order_id, :machine_id, :machine]
  def_delegators :@production_order_item, *Delegators

  def initialize(production_order_item)
    @production_order_item=production_order_item
    self.origin=production_order_item
    self.delegators=Delegators
  end

  def to_bundle_produce_order
    kanban=@production_order_item.kanban
    {
     Id:@production_order_item.id,
     ItemNr:@production_order_item.nr,
     TotalQuantity:kanban.quantity,
     BundleQuanity:kanban.bundle,
     ProducedQty:@production_order_item.produced_qty
    }
  end

  def to_check_material_order
    kanban=@production_order_item.kanban
    process_entity=kanban.process_entities.first
    wire=Part.find_by_id(process_entity.value_wire_nr)
    t1=Part.find_by_id(process_entity.value_t1)
    tool1=t1.nil? ? nil : t1.tool

    t2=Part.find_by_id(process_entity.value_t2)
    tool2=t2.nil? ? nil : t2.tool

    # s1=Part.find_by_id(process_entity.value_s1)
    # s2=Part.find_by_id(process_entity.value_s2)
    {
        Id: @production_order_item.id,
        ItemNr: @production_order_item.nr,
        OrderNr: @production_order_item.production_order.nr,
        FileName: "#{@production_order_item.nr}.json",
        WireNr: wire.nr,
        WireCusNr: wire.custom_nr||'',
        WireLength: process_entity.value_wire_qty_factor.to_f,
        Terminal1Nr: t1.nil? ? nil : t1.nr,
        Terminal1CusNr: t1.nil? ? nil : t1.custom_nr,
        Terminal1StripLength: process_entity.t1_strip_length.nil? ? nil : process_entity.t1_strip_length.to_f,
        Tool1Nr: tool1.nil? ? nil : tool1.nr,
        Terminal2Nr: t2.nil? ? nil : t2.nr,
        Terminal2CusNr: t2.nil? ? nil : t2.custom_nr,
        Terminal2StripLength: process_entity.t2_strip_length.nil? ? nil : process_entity.t2_strip_length.to_f,
        Tool2Nr: tool2.nil? ? nil : tool2.nr
    }
  end

  def to_produce_order
    Ncr::Order.new.json_order_item_content(@production_order_item)
  end
end