class Position < ActiveRecord::Base
  belongs_to :warehouse

  validates :detail, presence: true, uniqueness: {message: 'detail should be uniq'}
end
