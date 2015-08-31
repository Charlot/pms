puts "测试库存，自动生成库存"

Storage.destroy_all

Kanban.all.each do |k|
  begin
    Storage.add(k.full_wire_nr,k.quantity,k.des_storage)
  rescue => e
    puts e.message
  end
end