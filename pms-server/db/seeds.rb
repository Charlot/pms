# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
puts '------init department------'
puts 'create Assembly'
unless Department.find_by_code('A')
  Department.create(name: 'Assembly', code: 'A')
end

puts 'create Cutting'
unless Department.find_by_code('C')
  Department.create(name: 'Cutting', code: 'C')
end

puts 'update machine time'
Machine.update_all(print_time: 45, seal_time: 40, terminal_time: 15, wire_time: 5)

puts 'Create users'
User.transaction do
  unless caigaoming = User.find_by_user_name("gaoming.cai")
    caigaoming = User.create({user_name: "gaoming.cai", password: "caigaoming123", password_confirmation: "caigaoming123"})
    caigaoming.add_role :admin
  end

  unless xulin = User.find_by_user_name("lin.xu")
    xulin = User.create({user_name: "lin.xu", password: "xulin456", password_confirmation: "xulin456"})
    xulin.add_role :admin
  end

  unless mayunmia = User.find_by_user_name("yunxia.ma")
    mayunmia = User.create({user_name: "yunxia.ma", password: "mayunxia789", password_confirmation: "mayunxia789"})
    mayunmia.add_role :av
  end

  unless wangbaofeng = User.find_by_user_name("baofeng.wang")
    wangbaofeng = User.create({user_name: "baofeng.wang", password: "wangbaofeng012", password_confirmation: "wangbaofeng012"})
    wangbaofeng.add_role :av
  end

  unless sujun = User.find_by_user_name("jun.su")
    sujun = User.create({user_name: "jun.su", password: "sujun345", password_confirmation: "sujun345"})
    sujun.add_role :av
  end

  unless sunxinqi = User.find_by_user_name("xinqi.sun")
    sunxinqi = User.create({user_name: "xinqi.sun", password: "sunxinqi678", password_confirmation: "sunxinqi678"})
    sunxinqi.add_role :av
  end


  unless wangying = User.find_by_user_name("ying.wang")
    wangying = User.create({user_name: "ying.wang", password: "wangying901", password_confirmation: "wangying901"})
    wangying.add_role :kanban
  end


  unless huangjianyun = User.find_by_user_name("jianyun.huang")
    huangjianyun = User.create({user_name: "jianyun.huang", password: "huangjianyun567", password_confirmation: "huangjianyun567"})
    huangjianyun.add_role :kanban
  end

  unless sunlihong = User.find_by_user_name("lihong.sun")
    sunlihong = User.create({user_name: "lihong.sun", password: "sunlihong234", password_confirmation: "sunlihong234"})
    sunlihong.add_role :admin
  end

  unless system = User.find_by_user_name("system")
    system = User.create({user_name: "system", password: "123456system", password_confirmation: "123456system"})
    system.add_role :system
  end
end

puts 'create setting regex...'
Setting.transaction do
  unless Setting.find_by_code(Setting::AUTO_MOVE_KANBAN_CODE)
    Setting.create(code: Setting::AUTO_MOVE_KANBAN_CODE, value: '0', name: '自动销卡')
  end

  unless Setting.find_by_code(Setting::ROUTING_MATERIAL_LENGTH_UNIT)
    Setting.create(code: Setting::ROUTING_MATERIAL_LENGTH_UNIT, value: 'mm', name: '步骤原材料线及管子等长度单位')
  end

  unless Setting.find_by_code(Setting::AUTO_CONVERT_MATERIAL_LENGTH)
    Setting.create(code: Setting::AUTO_CONVERT_MATERIAL_LENGTH, value: '1', name: '自动转换步骤原材料线及管子等长度')
  end

  unless Setting.find_by_code(Setting::MATERIAL_PART_MARK)
    Setting.create(code: Setting::MATERIAL_PART_MARK, value: 'L', name: '原材料线盘点备注')
  end

  unless Setting.find_by_code(Setting::NONE_MATERIAL_PART_MARK)
    Setting.create(code: Setting::NONE_MATERIAL_PART_MARK, value: 'M', name: '非原材料线盘点备注')
  end

  unless Setting.find_by_code(Setting::NONE_MATERIAL_PART_MARK)
    Setting.create(code: Setting::NONE_MATERIAL_PART_MARK, value: 'M', name: '非原材料线盘点备注')
  end

  unless Setting.find_by_code(Setting::KANBAN_QTY_CHANGE_ORDER)
    Setting.create(code: Setting::KANBAN_QTY_CHANGE_ORDER, value: '0', name: '看板改变量【立刻】改变未生产订单量')
  end

  unless Setting.find_by_code(Setting::PRESETER_CHANGE_ITEM_QTY)
    Setting.create(code: Setting::PRESETER_CHANGE_ITEM_QTY, value: '1', name: '看板改变量【查看订单时】改变未生产订单量')
  end
end

puts 'create warehouse regex...'
WarehouseRegex.transaction do
  [
      {regex: '^MC', warehouse_nr: 'SRPL'},
      {regex: '^FC', warehouse_nr: 'SRPL'},
      {regex: '^TC', warehouse_nr: 'SRPL'},
      {regex: '^XM', warehouse_nr: '3PL'},
      {regex: '^XF', warehouse_nr: '3PL'},
      {regex: '^XT', warehouse_nr: '3PL'},

      {regex: '^AM1', warehouse_nr: 'SRPL'},
      {regex: '^AM2', warehouse_nr: 'SRPL'},
      {regex: '^AM9', warehouse_nr: 'SRPL'},

      {regex: '^BT1', warehouse_nr: 'SRPL'},
      {regex: '^BT2', warehouse_nr: 'SRPL'},
      {regex: '^BT9', warehouse_nr: 'SRPL'},

      {regex: '^AY1', warehouse_nr: 'SRPL'},
      {regex: '^AY2', warehouse_nr: 'SRPL'},
      {regex: '^AY9', warehouse_nr: 'SRPL'},

      {regex: '^QM1', warehouse_nr: 'SRPL'},
      {regex: '^QM2', warehouse_nr: 'SRPL'},
      {regex: '^QM9', warehouse_nr: 'SRPL'},

      {regex: '^QE1', warehouse_nr: 'SRPL'},
      {regex: '^QE2', warehouse_nr: 'SRPL'},
      {regex: '^QE9', warehouse_nr: 'SRPL'},

      {regex: '^CQ1', warehouse_nr: 'SRPL'},
      {regex: '^CQ2', warehouse_nr: 'SRPL'},
      {regex: '^CQ9', warehouse_nr: 'SRPL'},

      {regex: '^CF1', warehouse_nr: 'SRPL'},
      {regex: '^CF2', warehouse_nr: 'SRPL'},
      {regex: '^CF9', warehouse_nr: 'SRPL'},

      {regex: '^CE1', warehouse_nr: 'SRPL'},
      {regex: '^CE2', warehouse_nr: 'SRPL'},
      {regex: '^CE9', warehouse_nr: 'SRPL'},


      {regex: '^YF1', warehouse_nr: 'SRPL'},
      {regex: '^YF2', warehouse_nr: 'SRPL'},
      {regex: '^YF9', warehouse_nr: 'SRPL'},

      {regex: '^DM1', warehouse_nr: 'SRPL'},
      {regex: '^DM2', warehouse_nr: 'SRPL'},
      {regex: '^DM9', warehouse_nr: 'SRPL'},

      {regex: '^DE1', warehouse_nr: 'SRPL'},
      {regex: '^DE2', warehouse_nr: 'SRPL'},
      {regex: '^DE9', warehouse_nr: 'SRPL'},

      {regex: '^SM1', warehouse_nr: 'SRPL'},
      {regex: '^SM2', warehouse_nr: 'SRPL'},
      {regex: '^SM9', warehouse_nr: 'SRPL'},

      {regex: '^AM3', warehouse_nr: '3PL'},
      {regex: '^BT3', warehouse_nr: '3PL'},
      {regex: '^AY3', warehouse_nr: '3PL'},
      {regex: '^QM3', warehouse_nr: '3PL'},
      {regex: '^QE3', warehouse_nr: '3PL'},
      {regex: '^CQ3', warehouse_nr: '3PL'},
      {regex: '^CF3', warehouse_nr: '3PL'},
      {regex: '^CE3', warehouse_nr: '3PL'},
      {regex: '^YF3', warehouse_nr: '3PL'},
      {regex: '^DM3', warehouse_nr: '3PL'},
      {regex: '^DE3', warehouse_nr: '3PL'},
      {regex: '^SM3', warehouse_nr: '3PL'}
  ].each do |v|
    unless WarehouseRegex.where(v).first
      WarehouseRegex.create(v)
    end
  end
end