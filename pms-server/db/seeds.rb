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
unless user = User.find_by_user_name("admin")
  user = User.create({user_name:"admin",password:"123456@",password_confirmation:"123456@"})
end