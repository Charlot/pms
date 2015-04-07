json.array!(@machine_combinations) do |machine_combination|
  json.extract! machine_combination, :id, :w1, :t1, :t2, :s1, :s2, :wd1, :w2, :t3, :t4, :s3, :s4, :wd2, :machine_id
  json.url machine_combination_url(machine_combination, format: :json)
end
