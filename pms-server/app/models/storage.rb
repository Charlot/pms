class Storage < ActiveRecord::Base
  #belongs_to :warehouse
  belongs_to :part
  belongs_to :position

  delegate :nr, to: :part,prefix: true, allow_nil: true
  delegate :parsed_nr, to: :part, prefix: true, allow_nil: true
  delegate :detail, to: :position, prefix: true, allow_nil: true

  validates_uniqueness_of :part_id, :scope => :position_id

  scoped_search in: :part,on: :nr
  scoped_search in: :position,on: :detail

  has_paper_trail

  # 添加库存
  # 参数: 零件号（完整的零件号，针对线号而言），数量，以及位置
  # 返回storage实例
  def self.add(part_nr,quantity,position_detail=nil)
    part = Part.find_by_nr(part_nr)
    raise "Part not found" if part.nil?
    storage = nil
    if position_detail.nil?
      storage = where({part_id:part.id,position_id: nil}).first
      if storage
        storage.update(quantity:storage.quantity+quantity)
      else
        storage = create({part_id:part.id,quantity:quantity})
      end
    end

    position = Position.find_by_detail(position_detail)
    raise "Position not found" if position.nil?

    storage = where({part_id:part.id,position_id: position.id}).first

    if storage
      storage.update(quantity:(storage.quantity+quantity))
    else
      storage = create({part_id:part.id,position_id:position.id,quantity:quantity})
    end
    storage
  end

  # 删除库存
  # 抛出异常或者返回storage实例
  def self.reduce(part_nr,quantity,position_detail=nil)
    part = Part.find_by_nr(part_nr)
    raise "Part not found" if part.nil?

    storage = nil

    if position_detail
      storage = where({part_id:part.id,position_id: nil}).first
      if storage
        if storage.quantity >= quantity
          storage.update(quantity:storage.quantity-quantity)
        else
          raise "Storage is out of stock"
        end
      else
        raise "Storage not found"
      end
    end

    position = Position.find_by_detail(position_detail)
    raise "Position not found" if position.nil?

    storage = where({part_id:part.id,position_id: position.id}).first

    if storage
      if storage.quantity >= quantity
        storage.update(quantity:(storage.quantity-quantity))
      else
        raise "Storage is out of stock"
      end
    else
      raise "Storage not found"
    end

    storage
  end
end
