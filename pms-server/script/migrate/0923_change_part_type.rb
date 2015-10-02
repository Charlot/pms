Part.transaction do
  {
      '0' => 100,
      '1' => 200,
      '2' => 300,
      '3' => 400,
      '6' => 500,
      '4' => 600,
      '5' => 700
  }.each do |k, v|
    puts "------------#{k}---#{v}---------------".red
    Part.where(type: k.to_i).update_all(type: v)
  end
end