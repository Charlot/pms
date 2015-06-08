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
  unless admin = User.find_by_user_name("admin")
    admin = User.create({user_name: "admin", password: "123456", password_confirmation: "123456"})
    admin.add_role :admin
  end

  unless av = User.find_by_user_name("av")
    av = User.create({user_name: "av", password: "123456", password_confirmation: "123456"})
    av.add_role :av
  end

  unless cutting = User.find_by_user_name("cutting")
    cutting = User.create({user_name: "cutting", password: "123456", password_confirmation: "123456"})
    cutting.add_role :cutting
  end

  unless system = User.find_by_user_name("system")
    system = User.create({user_name: "system", password:"123456",password_confirmation:"123456"})
    system.add_role :system
  end
  #
  # unless test=User.find_by_user_name("test")
  #   test = User.create({user_name: "test", password:"123456",password_confirmation:"123456"})
  #   test.add_role :admin
  # end


  unless kanban=User.find_by_user_name("kanban")
    kanban = User.create({user_name: "kanban", password:"123456",password_confirmation:"123456"})
    kanban.add_role :kanban
  end


  User.destroy_all
  #

  unless caigaoming = User.find_by_user_name("gaoming.cai")
    caigaoming = User.create({user_name: "gaoming.cai", password: "caigaoming123", password_confirmation: "caigaoming123"})
    caigaoming.add_role :admin
  end

  unless xulin = User.find_by_user_name("lin.xu")
    xulin = User.create({user_name: "lin.xu", password: "xulin456", password_confirmation: "xulin456"})
    xulin.add_role :admin
  end

  unless mayunmia = User.find_by_user_name("yunxia.ma")
    mayunmia = User.create({user_name: "yunxia.ma", password: "mayunmia789", password_confirmation: "mayunmia789"})
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


  unless sunlihong = User.find_by_user_name("lihong.sun")
    sunlihong = User.create({user_name: "lihong.sun", password: "sunlihong234", password_confirmation: "sunlihong234"})
    sunlihong.add_role :kanban
  end

  unless system = User.find_by_user_name("system")
    system = User.create({user_name: "system", password:"123456system",password_confirmation:"123456system"})
    system.add_role :system
  end
end