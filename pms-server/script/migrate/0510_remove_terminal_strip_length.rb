CustomField.where(name:%w(t1_strip_length t2_strip_length)).each do |cf|
  puts "#{cf.id}---#{cf.name}"
  cf.custom_values.destroy_all
end