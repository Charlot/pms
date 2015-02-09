class CustomField < ActiveRecord::Base
  self.inheritance_column = nil #:_type_disabled

  has_many :custom_values, :dependent => :delete_all
  belongs_to :custom_fieldable, polymorphic: true
  scope :sorted, lambda { order(:position) }

  def validate_format_field(args)
    become_to.validate_field(args)
  end

  def validate_field(args)
    true
  end


  def get_field_format_value(args)
    become_to.get_field_value(args)
  end

  def get_field_value(args)
    args
  end

  def self.parse_args(arg)
    unless arg.is_a?(Array)
      arg=([]<<arg)
    end
    arg
  end

  def self.build_by_format(field_format, name, type)
    to_constantize(field_format).build_default(field_format, name, type)
  end

  def self.build_default(field_format, name, type)
    new(name: name,
        field_format: field_format,
        default_value: '0',
        description: "dynamic template default custom field, #{name}")
  end

  private
  def become_to
    self.becomes(CustomField.to_constantize(self.field_format))
  end

  def self.to_constantize(field_format)
    "custom_field_#{field_format}".classify.constantize
  end
end
