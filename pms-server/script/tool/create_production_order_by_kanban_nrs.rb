#puts ARGV[0]
nrs = ARGV[0].split(";")
puts nrs.count
#puts nrs
Kanban.where(nr:nrs).each do |k|

end