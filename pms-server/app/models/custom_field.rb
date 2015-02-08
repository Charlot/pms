class CustomField < ActiveRecord::Base
  self.inheritance_column = nil #:_type_disabled

  has_many :custom_values, :dependent => :delete_all

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

  private
  def become_to
    self.becomes("custom_field_#{self.field_format}".classify.constantize)
  end
end
