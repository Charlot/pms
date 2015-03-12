require 'roo'

class Part < ActiveRecord::Base
  belongs_to :resource_group
  belongs_to :measure_unit
  has_many :part_boms
  has_many :part_process_entities,dependent: :destroy
  has_many :process_entities ,through: :part_process_entities
  has_many :kanbans
  has_one :resource_group_part
  # delegate :resource_group_tool, to: :resource_group_part
  has_one :resource_group_tool, through: :resource_group_part

  validates :nr, presence: true, uniqueness: {message: 'part nr should be uniq'}

  after_save :update_cv_strip_length

  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      allowed_attributes = [ "id","nr","custom_nr","type","strip_length","resource_group_id","measure_unit_id","created_at","updated_at"]
      part = find_by_id(row["id"]) || new
      part.attributes = row.to_hash.select { |k,v| allowed_attributes.include? k}
      part.save!
    end

      # CSV.foreach(file.path, headers: true) do |row|
 #      Part.create! row.to_hash
    # end
  end
  
  def self.open_spreadsheet(file)
      case File.extname(file.original_filename)
      when ".csv" then Roo::Csv.new(file.path)
      when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
      when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
      else raise "Unknown file type: #{file.original_filename}"
      end
  end

  private
  def update_cv_strip_length
    if self.strip_length_changed?
    end
  end
end
