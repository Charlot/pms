module Printer
  module Extend
    class ProcessTemplate2410
      def self.process_route_part_info_text(pe)
        template=pe.process_template
        cfs=template.custom_fields
        cfvs=pe.custom_field_values
        puts "***#{cfs.to_s}"
        puts "---#{cfvs.to_s}"
        if template.template
          total=0
          info_text= pe.process_template.template.gsub(/{\d+}/).each do |v|
            puts "#####{v}"
            if cf=cfs.detect { |f|
              puts "#{v.to_i}~~~#{f.id.to_i==v.to_i}"
              f.id.to_i==v.scan(/{(\d+)}/).map(&:first).first.to_i }
              puts "********************#{cf.to_json}"
              cfv=cfvs.detect { |v| v.custom_field_id==cf.id }
              if CustomFieldFormatType.part?(cf.field_format) && (part=Part.find_by_id(cfv.value))
                if (auto_pe = ProcessEntity.joins(custom_values: :custom_field).where(
                    {product_id: pe.product_id, custom_fields: {name: "default_wire_nr"}, custom_values: {value: part.id}}
                ).first) && (p=Part.find_by_id(auto_pe.value_wire_nr))
                  total+=p.cross_section
                  p.cross_section.to_zero_s+p.nr
                else
                  ''
                end
              else
                ''
              end
            else
              'ERROR'
            end
          end
          info_text
          # puts "~~~~~~~~~~~~~~~~~~~~~~#{info_text}".yellow
          if m=info_text.match(/\d+.*\d+/)
            m[0].sub(/\[\]/,"[#{total}]")
          else
            ''
          end
        else
          ''
        end

      end
    end
  end
end