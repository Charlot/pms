class Storage < ActiveRecord::Base
  #belongs_to :warehouse
  belongs_to :part
  belongs_to :position

  delegate :nr, to: :part,prefix: true, allow_nil: true
  delegate :detail, to: :position, prefix: true, allow_nil: true

  validates_uniqueness_of :part_id, :scope => :position_id

  def self.add(part,quantity,position)
    part = Part.find_by_nr(part)
    position = Position.find_by_detail(position)

    raise "Part not found" if part.nil?
    raise "Position not found" if position.nil?

    storage = where({part_id:part.id,position_id: position.id}).first

    if storage
      storage.update(quantity:(storage.quantity+quantity))
    else
      create({part_id:part.id,position_id:position.id,quantity:quantity})
    end
  end

  def self.reduce(part,quantity,position)
    part = Part.find_by_nr(part)
    position = Position.find_by_detail(position)

    raise "Part not found" if part.nil?
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
