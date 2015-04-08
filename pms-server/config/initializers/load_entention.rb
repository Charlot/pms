Dir["#{Rails.root}/lib/active_support/**/*.rb"].each do |file|
  require file
end
