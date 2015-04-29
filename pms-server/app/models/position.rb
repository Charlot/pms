class Position < ActiveRecord::Base
  belongs_to :warehouse
  delegate :nr, to: :warehouse, prefix: true, allow_nil: true

  validates :detail, presence: true, uniqueness: {message: 'detail should be uniq'}
end
