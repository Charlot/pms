class AutoScrapRecord < ActiveRecord::Base

  validates_uniqueness_of :scrap_id
  validate :validate_save
  # after_initialize :generate_scrap_id
  #
  # def generate_scrap_id
  #   self.scrap_id = self.send(:generate_id) if self.id.nil? && self.respond_to?(:generate_id)
  #   self.id = SecureRandom.uuid if self.id.nil?
  # end

  def validate_save
    errors.add(:scrap_id, '编号不可为空') if self.scrap_id.blank?
  end

  def self.generate_scrap_id
    "BF#{Time.now.to_milli}"
  end


end
