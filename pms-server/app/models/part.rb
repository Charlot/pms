require 'roo'
require 'csv'

class Part < ActiveRecord::Base
  self.inheritance_column = :_type_disabled
  belongs_to :resource_group
  belongs_to :measure_unit
  has_many :part_boms
  has_many :part_process_entities, dependent: :destroy
  has_many :process_entities, through: :part_process_entities
  has_many :kanbans
  has_one :resource_group_part
  # delegate :resource_group_tool, to: :resource_group_part
  has_one :resource_group_tool, through: :resource_group_part
  has_one :tool
  validates :nr, presence: true, uniqueness: {message: 'part nr should be uniq'}

  # scoped_search on: [:nr, :type], ext_method: :find_by_part_type
  has_paper_trail
  scoped_search on: :nr

  after_update :update_cv_strip_length

  # def self.find_by_part_type key, operator, value
  #   type=PartType.get_value_by_display(value)
  #   # if type
  #   #   {conditions: "parts.type=#{type} and parts.nr like '%#{value}%'"}
  #   # else
  #     {conditions: ['parts.nr like ?',"'%#{value}%'"] }
  #   # end
  # end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
    end
  end

  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      allowed_attributes = ["id", "nr", "custom_nr", "type", "strip_length", "resource_group_id", "measure_unit_id", "created_at", "updated_at"]
      part = find_by_id(row["id"]) || new
      part.attributes = row.to_hash.select { |k, v| allowed_attributes.include? k }
      part.save!
    end

    # CSV.foreach(file.path, headers: true) do |row|
    #      Part.create! row.to_hash
    # end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
      when ".csv" then
        Roo::Csv.new(file.path)
      when ".xls" then
        Roo::Excel.new(file.path, nil, :ignore)
      when ".xlsx" then
        Roo::Excelx.new(file.path, nil, :ignore)
      else
        raise "Unknown file type: #{file.original_filename}"
    end
  end

  # 获得某个步骤中使用的零件的库位
  def positions(kanban_id, product_id, process_entity)
    #如果是零件，则直接在PartPosition中查找
    if PartType.is_material?(self.type)
      pp = PartPosition.find_by_part_id(self.id)
      pp.nil? ? ["N/A"] : [pp.storage]
    else
      #如果不是
      kanbans = []
      puts "#{self.nr}".red

      kanban = Kanban.find_by_id(kanban_id)

      store = kanban.des_storage.split(" ").first

      cutting_storage = ["FC","MC","TC"]
      assembly_storage = ["XF","XM","XT"]

      # 如果当前看板卡的宋辽位置在cutting_storage 中
      # 也就是送往半自动线架再加工的
      # 那么，找生产该零件的白卡的送料位置
      if store.present? && (cutting_storage.include? store)
        kanbans = Kanban.joins(process_entities: {custom_values: :custom_field}).where(
            "kanbans.ktype = ? AND kanbans.id != ? AND kanbans.product_id = ? AND custom_values.value = ? AND custom_fields.field_format = 'part'", KanbanType::WHITE, kanban_id, product_id, self.id
        ).distinct
      else
        # 如果是送往总装的
        # 那么，先找蓝卡
        kanbans = Kanban.joins(process_entities: :process_parts).where(
            "kanbans.ktype = ? AND kanbans.id != ? AND kanbans.product_id = ? AND process_parts.part_id = ?",KanbanType::BLUE,kanban_id,product_id,self.id
        ).distinct

        # 去除也是送往总装的蓝卡
        # 因为我们要查找的是，送往半自动线架的蓝卡
        kks = []
        kanbans.each{|k|
          store = k.des_storage.split(" ").first
          unless assembly_storage.include?(store)
            kks << k
          end
        }

        puts kks

        # 如果没有找到，则寻找白卡的送料位置
        if kks.count <=0
          kanbans = Kanban.joins(process_entities: {custom_values: :custom_field}).where(
              "kanbans.ktype = ? AND kanbans.id != ? AND kanbans.product_id = ? AND custom_values.value = ? AND custom_fields.field_format = 'part'",KanbanType::WHITE,kanban_id,product_id,self.id
          ).distinct
        else
          kanbans = kks
        end
      end
      # case process_entity.process_template.wire_from
      #   when WireFromType::SEMI_AUTO
      #     puts "#{process_entity.nr},#{process_entity.process_template.wire_from},SEMI_AUTO".red
      #     kanbans = Kanban.joins(process_entities: :process_parts).where(
      #         "kanbans.ktype = ? AND kanbans.id != ? AND kanbans.product_id = ? AND process_parts.part_id = ?",KanbanType::BLUE,kanban_id,product_id,self.id
      #     ).distinct
      #   when WireFromType::AUTO
      #     puts "#{process_entity.nr},#{process_entity.process_template.wire_from},AUTO".red
      #     kanbans = Kanban.joins(process_entities: {custom_values: :custom_field}).where(
      #         "kanbans.ktype = ? AND kanbans.id != ? AND kanbans.product_id = ? AND custom_values.value = ? AND custom_fields.field_format = 'part'",KanbanType::WHITE,kanban_id,product_id,self.id
      #     ).distinct
      #   else
      # end
      puts "#{kanbans.collect { |k| k.nr }.join(',')}".red
      kanbans.collect { |k| k.des_storage }
    end
  end

  # 线号，比如93AMN001A_279
  # 则这里显示279
  def parsed_nr
    if type == PartType::PRODUCT_SEMIFINISHED && nr.include?("_")
      nrs = nr.split("_")
      (nrs-[nrs.first]).join("_")
    else
      nr
    end
  end

  private
  def update_cv_strip_length
    if self.strip_length_changed?

    end
  end
end
