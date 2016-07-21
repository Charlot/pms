MeasuredValueRecord.transaction do
  MeasuredValueRecord.all.each do |mvr|
    mvr.update_attributes({machine_id: mvr.part_id, part_id: ''})
  end
end