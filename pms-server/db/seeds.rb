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

  unless user = User.find_by_user_name("av")
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

  unless test=User.find_by_user_name("test")
    test = User.create({user_name: "test", password:"123456",password_confirmation:"123456"})
    test.add_role :admin
  end
end