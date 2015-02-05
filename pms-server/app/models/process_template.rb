class ProcessTemplate < ActiveRecord::Base
  self.inheritance_column = :_type_disabled
  validates :code, presence: {message: 'code cannot be blank'}, uniqueness: {message: 'code should be uniq'}

  acts_as_customizable
  #
  # before_create :init_attr
  #
  #
  # def init_attr
  #   puts '***************'
  #   puts self.class.name.sub(/ProcessTemplate/, '')
  #   puts self.class.name
  #   puts '**************************8888888'
  #   # self.type=ProcessType.get_type(self.class.name.sub(/ProcessTemplate/, ''))
  # end

  def custom_field_type
    @custom_field_type || (self.id.nil? ? nil : "#{self.id}_#{self.class.name}")
  end

end
