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

  def self.add(part_nr,quantity,position_detail=nil)
    part = Part.find_by_nr(part_nr)
    raise "Part not found" if part.nil?

    if position_detail.nil?
      storage = where({part_id:part.id,position_id: nil}).first
      if storage
        storage.update(quantity:storage.quantity+quantity)
      else
        create({part_id:part.id,quantity:quantity})
      end
    end

    position = Position.find_by_detail(position_detail)
    raise "Position not found" if position.nil?

    storage = where({part_id:part.id,position_id: position.id}).first

    if storage
      storage.update(quantity:(storage.quantity+quantity))
    else
      create({part_id:part.id,position_id:position.id,quantity:quantity})
    end
  end

  def self.reduce(part_nr,quantity,position_detail=nil)
    part = Part.find_by_nr(part_nr)
    raise "Part not found" if part.nil?

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
  end
end
