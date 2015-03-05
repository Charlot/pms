class MachineCombination < ActiveRecord::Base
  belongs_to :machine

  # validate :validate_part

  # private
  # def validate_part
  #   no_error=true
  #   [:w1, :t1, :t2, :s1, :s2, :w2, :t3, :t4, :s3, :s4].each do |field|
  #     puts "#{field}-----------#{self.send(field.to_s)}"
  #     if part=Part.find_by_nr(self.send(field))
  #       self.send("#{field}=", part.id)
  #     else
  #       no_error=false
  #       errors.add(field, 'part not exists')
  #     end unless self.send(field).blank?
  #     # mp[field]= (part=Part.find_by_nr(mp[field])).nil? ? nil : part.id
  #   end
  #   return false
  # end
end
