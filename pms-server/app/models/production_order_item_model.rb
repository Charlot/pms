class ProductionOrderItemModel
  include ActiveModel::Model

  attr_accessor :id, :wire_nr, :t1, :t2, :s1, :s2, :order_item

  def self.initialize_items(order_items)
    items=[]
    order_items.each do |item|
     # t1, t2=item.t1 <item.t2 ? [item.t1, item.t2] : [item.t2, item.t1]
     # s1, s2=item.s1 <item.s2 ? [item.s1, item.s2] : [item.s2, item.s1]
     # items<<self.new(id: item.id, wire_nr: item.wire_nr, t1: t1, t2: t2, s1: s1, s2: s2, order_item: item)
      items<<self.new(id: item.id, wire_nr: item.wire_nr, t1: item.t1, t2: item.t2, s1: item.s1, s2: item.s2, order_item: item)
    end
    items= items.sort_by { |item| [item.t1,item.t2] }
    items.each_with_index do |item,i|
      puts "#{i}...#{item.t1}-----------#{item.t2}".blue
    end
    return items
  end


end