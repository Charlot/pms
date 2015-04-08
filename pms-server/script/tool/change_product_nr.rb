old_nr = ARGV[0]
new_nr = ARGV[1]

Part.transaction do
  begin
    #修改总成号零件号
    product = Part.where({nr: old_nr, type: PartType::PRODUCT}).first
    if product && product.update({nr: new_nr})
      puts "修改成品#{product.nr}".green
      #修改半自动零件号
      Part.where("nr like ? AND TYPE = ?", old_nr, PartType::PRODUCT_SEMIFINISHED).each do |part|
        puts "修改半成品#{part.nr}".green
        nr = part.nr.split("_").last
        part.update({nr: "#{new_nr}_#{nr}"})
      end
    end
  rescue => e
    puts e.backtrace
  end
end
