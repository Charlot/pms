class WarehouseRegex < ActiveRecord::Base
  validates :regex, presence: {message: '正则不可为空，且必须唯一'}, uniqueness: {message: '正则不可为空，且必须唯一'}
  validates :warehouse_nr, presence: {message: '仓库号不可为空'}

end
