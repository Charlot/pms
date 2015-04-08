class KanbanDispatchTest
  def self.test
    kb=Kanban.first
    node=MachineCombination.init_node_by_kanban(kb)
    puts node.to_json
    list=MachineCombination.load_combinations
    puts list.to_json
    puts list.match(node)
  end

  def self.generate_product_order_item
    puts "----------------------------------------------".red
    puts "该操作将清空所有的生产订单，不能在生产环境下使用".red
    puts "----------------------------------------------".red

    ProductionOrder.destroy_all
    ProductionOrderItem.destroy_all

    Kanban.where({ktype: KanbanType::WHITE}).limit(100).each_with_index {|k,index|
      @kanban = k

      if ProductionOrderItem.where(kanban_id: @kanban.id, state: ProductionOrderItemState::INIT).count > 0
        next
      end

      k.update({quantity:10,bundle:2})

      unless (@order = ProductionOrderItem.create(kanban_id: @kanban.id,code:@kanban.printed_2DCode))
        next
      end

      puts "新建订单成功：#{k.nr}".green
      #
    }
  end
end

#KanbanDispatchTest.test
KanbanDispatchTest.generate_product_order_item