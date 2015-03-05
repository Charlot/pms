class ProcessTemplate < ActiveRecord::Base
  self.inheritance_column = :_type_disabled
  validates :code, presence: {message: 'code cannot be blank'}, uniqueness: {message: 'code should be uniq'}
  validates :template, presence: {message: 'template cannot be blank'}, if: Proc.new { |p| ProcessType.semi_auto?(p.type) }
  has_many :custom_fields, lambda { order("#{CustomField.table_name}.position") }, as: :custom_fieldable

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
    end
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
end
