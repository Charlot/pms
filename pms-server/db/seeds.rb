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

Setting.transaction do
  unless Setting.find_by_code('auto_move_kanban')
    Setting.create(code: Setting::AUTO_MOVE_KANBAN_CODE, value: '0', name: '自动销卡')
  end
end
