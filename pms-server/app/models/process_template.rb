require 'roo'
require 'csv'

class ProcessTemplate < ActiveRecord::Base
  self.inheritance_column = :_type_disabled
  validates :code, presence: {message: 'code cannot be blank'}, uniqueness: {message: 'code should be uniq'}
  validates :template, presence: {message: 'template cannot be blank'}, if: Proc.new { |p| ProcessType.semi_auto?(p.type) }
  has_many :custom_fields, lambda { order("#{CustomField.table_name}.position") }, as: :custom_fieldable
  has_many :process_entities, dependent: :destroy

  before_create :parse_template_into_cf, if: Proc.new { |p| ProcessType.semi_auto?(p.type) }
  after_create :parse_cf_into_template, if: Proc.new { |p| ProcessType.semi_auto?(p.type) }
  acts_as_customizable

  def custom_field_type
    @custom_field_type ||= (self.id.nil? ? nil : "#{self.id}_#{self.class.name}")
  end

  def parse_template_into_cf
    puts "#{self.new_record?}-----------------------"
    puts self.template
    index=Hash.new(0)
    count=0
    self.template.scan(/{(\w+)}/).map(&:first).map(&:downcase).each_with_index do |format, i|
      puts "**********************#{format}"
      format_key=format.to_sym
      cf=CustomField.build_by_format(format, "#{format}_#{index[format_key]}", self.custom_field_type, i)
      puts '----------------'
      self.custom_fields<<cf
      # puts cf.to_json
      # cf.save
      puts '----------------'
      index[format_key] +=1
      count=i
    end
    self.custom_fields << CustomField.build_by_format("part", "default_wire_nr", self.custom_field_type, count+1)
    puts '*************************'
    puts self.template
    puts '*************************'
    # raise
  end

  def parse_cf_into_template
    self.template.gsub!(/{\w+}/).each_with_index { |v, i| "{#{self.custom_fields[i].id}}" }
    puts '*************************'
    puts self.template
    self.save
    puts '*************************'
  end

  def template_display_text
    @template_display_text||=self.template.gsub(/{\d+}/, ' ________')
  end

  def template_texts
    @template_texts||=self.template.split(/{\d+}/)
  end

  def template_custom_field_ids
    @template_custom_field_ids||=self.template.scan(/{(\d+)}/).map(&:first)
  end

  # 导入自动模版

  def self.import(file, import_type)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      allowed_attributes = ["code", "name", "template", "description"]
      process_template = find_by_code(row["code"]) || new
      process_template.attributes = row.to_hash.select { |k, v| allowed_attributes.include? k }

      ProcessTemplate.transaction do

        case import_type
          when 'auto'
            process_template.type = 100
            auto_attributes = ["default_wire_nr", "wire_nr", "wire_qty_factor", "default_bundle_qty", "t1", "t1_default_strip_length", "t1_qty_factor", "t1_strip_length", "t2", "t2_qty_factor", "t2_default_strip_length", "t2_strip_length", "s1", "s1_qty_factor", "s2", "s2_qty_factor"]
            custom_fields = {}
            custom_fields = row.to_hash.select { |k1, v1| auto_attributes.include? k1 }

            ProcessTemplateAuto.build_custom_fields(custom_fields.select { |k, v| !v.nil? }.keys, process_template).each do |cf|
              # cf.save
              process_template.custom_fields<<cf
            end
            process_template.save!

          when 'semi'

          when 'manual'
            process_template.type = 300
            process_template.save!
          else
            raise ' No such process template'
        end

      end
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
      when ".csv" then
        Roo::Csv.new(file.path)
      when ".xls" then
        Roo::Excel.new(file.path, nil, :ignore)
      when ".xlsx" then
        Roo::Excelx.new(file.path, nil, :ignore)
      else
        raise "Unknown file type: #{file.original_filename}"
    end
  end
end
