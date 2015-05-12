Tool.all.each do |t|
  puts "#{t.id}--#{t.nr}"
  t.update(nr_display: t.nr.sub(/WZ/, ''))
  t.update(nr: "WZ#{t.nr_display}")
end