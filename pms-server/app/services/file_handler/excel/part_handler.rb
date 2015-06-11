module FileHandler
  module Excel
    class PartHandler<Base
      HEADERS=['Part Nr', 'Custom Nr', 'Type', 'Strip Length', 'Color', 'Color Desc', 'Component Type', 'Cross Section', 'Operator']

      def self.export(q=nil)
        msg = Message.new
        begin
          tmp_file = full_export_path("(#{q})Part.xlsx")

          p = Axlsx::Package.new
          p.workbook.add_worksheet(:name => "Basic Worksheet") do |sheet|
            sheet.add_row HEADERS
            parts = []
            if q.nil?
              parts= Part.all
            else
              parts = Part.search_for(q).all
            end

            parts.each do |part|
              sheet.add_row [
                                part.nr,
                                part.custom_nr,
                                part.type,
                                part.strip_length,
                                part.color,
                                part.color_desc,
                                part.component_type,
                                part.cross_section,
                                'update'
                            ], types: [:string, :string]
            end
          end

          p.use_shared_strings = true
          p.serialize(tmp_file)

          msg.result =true
          msg.content =tmp_file
        rescue => e
          msg.content =e.message
        end
        msg
      end
    end
  end
end