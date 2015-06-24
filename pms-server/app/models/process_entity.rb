class ProcessEntity < ActiveRecord::Base
  validates :nr, presence: {message: 'nr cannot be blank'}
  validates_uniqueness_of :nr, :scope => :product_id
  # include PartBomable


  belongs_to :process_template
  belongs_to :workstation_type
  belongs_to :cost_center
  belongs_to :product, class_name: 'Part'
  has_many :kanban_process_entities, dependent: :destroy
  has_many :kanbans, through: :kanban_process_entities
  has_many :process_parts
  has_many :parts, through: :process_parts
  has_many :custom_values, as: :custom_fieldable

  delegate :custom_fields, to: :process_template, allow_nil: true
  delegate :nr, to: :product, prefix: true, allow_nil: true
  delegate :code, to: :process_template, prefix: true, allow_nil: true
  delegate :type, to: :process_template, prefix: true, allow_nil: true

  acts_as_customizable

  has_paper_trail

  scoped_search on: :nr
  scoped_search in: :product, on: :nr
  scoped_search in: :custom_values, on: :value, ext_method: :find_by_parts

  # after_create :build_process_parts

  def self.find_by_parts key, operator, value
    parts = Part.where("nr LIKE '%_#{value}%'").map(&:id)

    if parts.count > 0
      process = ProcessEntity.joins(custom_values: :custom_field).where(
          "custom_values.value IN (#{parts.join(',')}) AND custom_fields.field_format = 'part'"
      ).map(&:id)
      if process.count > 0
        return {conditions: "process_entities.id IN(#{process.join(',')})"}
      end
      {conditions: "process_entities.nr like '%#{value}%'"}
    end
    {conditions: "process_entities.nr LIKE '%#{value}%'"}
  end

  def template_fields
    a = []
    if self.process_template_type == ProcessType::SEMI_AUTO
      a = self.custom_fields.collect do |cf|
        if cf.name == "default_wire_nr"
          next
        end
        cv = self.custom_values.where(custom_field_id: cf.id).first

        if cf.field_format == 'part'
          if cv
            wire = Part.find_by_id(cv.value)
            if wire
              pp  = process_parts.where({part_id:wire.id}).first
              "#{wire.parsed_nr}|#{pp.quantity if pp}"
            else
              ""
            end
          else
            ""
          end
        else
          if cv
            cv.value
          else
            ""
          end
        end
      end
    else
      a= ["错误"]
    end
    puts a.to_json
    puts a.compact.to_json
    a.compact
  end

  # 目前只有6中操作方式
  # CC: 两端压端子
  # CW: 一端压端子，一端剥线
  # CS: 一端压端子，一端套防水圈
  # SW: 一端套防水圈，一端剥线
  # SS: 两端套防水圈
  # WW: 两端剥线
  # 下面的逻辑请对照上面的6中操作方式查看
  # 我问过徐工的逻辑是，
  # 压了端子，一定要剥线，
  # 套了防水圈，也是一定要剥线
  # 所以你可以看到我下面的判断的“先后顺序”
  def oee_code(oee = "")
    case oee
    when ""
      if value_t1 || value_t2
        oee = "C"
        oee_code(oee)
      elsif value_s1 || value_s2
        oee = "S"
        oee_code(oee)
      elsif value_t1_strip_length || value_t2_strip_length
        oee = "W"
        oee_code(oee)
      else
        oee << "-"
      end
    when "C"
      if value_t1 && value_t2
        oee << "C"
      elsif value_s1 || value_s2
        oee << "S"
      elsif ((value_t1.nil? && value_t1_strip_length) || (value_t2.nil? && value_t2_strip_length))
        oee << "W"
      else
        oee << "-"
      end
    when "W"
      if value_t1_strip_length && value_t2_strip_length
        oee << "W"
      elsif ((value_t1_strip_length.nil? && value_s1) || (value_t2_strip_length.nil? && value_s2))
        oee << "S"
      else
        oee << "-"
      end
    when "S"
      if value_s1 && value_s2
        oee << "S"
      elsif ((value_s1.nil? && value_t1_strip_length) || (value_s2.nil? && value_t2_strip_length))
        oee << "W"
      else
        oee << "-"
      end
    end
    oee
  end

  #
  def wire
    if self.value_default_wire_nr && (part = Part.find_by_id(self.value_default_wire_nr))
      return part
    end
    nil
  end

  def parsed_wire_nr
    wire.parsed_nr if wire
  end

  def wire_component
    if self.value_wire_nr && (part = Part.find_by_id(self.value_wire_nr))
      return part
    end
    nil
  end

  def custom_field_type
    puts '***************************************8'
    puts "#{self.process_template_id}_#{ProcessTemplate.name}"
    puts '***************************************8'

    @custom_field_type || (self.process_template_id.nil? ? nil : "#{self.process_template_id}_#{ProcessTemplate.name}")
  end


  def process_part_quantity_by_cf(cf_name)
    if quantity_cf_name=ProcessTemplateAuto.process_part_quantity_field(cf_name)
      self.send(quantity_cf_name)
    end
  end

  # for auto process entity
  def t1_strip_length
    @t1_strip_length=if self.value_t1_default_strip_length && (self.value_t1_default_strip_length.to_f!=0)
      self.value_t1_default_strip_length
    else
      self.value_t1_strip_length
    end
  end


  def t2_strip_length
    # @t2_strip_length||=(self.value_t2_default_strip_length || self.value_t2_strip_length )
    @t2_strip_length=if self.value_t2_default_strip_length && (self.value_t2_default_strip_length.to_f!=0)
                       self.value_t2_default_strip_length
                     else
                       self.value_t2_strip_length
                     end
  end

  def template_text
    template=self.process_template
    cfs=template.custom_fields
    cfvs=self.custom_field_values
    puts "***#{cfs.to_s}"
    puts "---#{cfvs.to_s}"
    if template.template
      self.process_template.template.gsub(/{\d+}/).each do |v|
        puts "#####{v}"
        if cf=cfs.detect { |f|
          puts "#{v.to_i}~~~#{f.id.to_i==v.to_i}"
          f.id.to_i==v.scan(/{(\d+)}/).map(&:first).first.to_i }
          puts "********************#{cf.to_json}"
          cfv=cfvs.detect { |v| v.custom_field_id==cf.id }
          CustomFieldFormatType.part?(cf.field_format) ? ((part=Part.find_by_id(cfv.value)).nil? ? '' : part.parsed_nr) : (cfv.value.nil? ? '' : cfv.value)
        else
          'ERROR'
        end
      end
    else
      ''
    end
  end
end
