json.array!(@machine_scopes) do |machine_scope|
  json.extract! machine_scope, :id, :w1, :t1, :t2, :s1, :s2, :wd1, :w2, :t3, :t4, :s3, :s4, :wd2, :machine_id
  json.url machine_scope_url(machine_scope, format: :json)
end
