require 'csv'
module FileHandler
  module Csv
    class ToolHandler<Base
      IMPORT_HEADERS=['Nr', 'Nr Display', 'Resource Group', 'Parts', 'MNT', 'Used Days', 'Rql', 'Tol', 'Rql Date', 'Operator']

      def self.import(file)
        msg = Message.new
        begin
          validate_msg = validate_import(file)
          if validate_msg.result
            CSV.foreach(file.file_path, headers: file.headers, col_sep: file.col_sep, encoding: file.encoding) do |row|
              row.strip
              Tool.transaction do
                rg = ResourceGroup.find_by_nr(row['Resource Group'])

                handle_parts=false
                case row['Operator']
                  when 'new', ''
                    tool = Tool.new({
                                        nr: row['Nr'],
                                        nr_display: row['Nr Display'],
                                        resource_group_id: rg.id,
                                        part_nrs: row['Parts'],
                                        mnt: row['MNT'],
                                        used_days: row['Used Days'],
                                        rql: row['Rql'],
                                        tol: row['Tol'],
                                        rql_date: row['Rql Date']
                                    })
                    handle_parts=tool.save
                  when 'update', 'destroy'
                    if tool = Tool.find_by_nr(row['Nr'])
                      #update
                      if row['Operator']=='update'
                        handle_parts= tool.update({
                                                      nr: row['Nr'],
                                                      nr_display: row['Nr Display'],
                                                      resource_group_id: rg.id,
                                                      part_nrs: row['Parts'],
                                                      mnt: row['MNT'],
                                                      used_days: row['Used Days'],
                                                      rql: row['Rql'],
                                                      tol: row['Tol'],
                                                      rql_date: row['Rql Date']
                                                  })
                      elsif row['Operator']=='delete'
                        tool.destroy
                      end
                    end
                end
              end
            end
            msg.result = true
            msg.content = '模具导入成功'
          else
            msg.result = false
            msg.content = validate_msg.content
          end
        rescue => e
          puts e.backtrace
          msg.result = false
          msg.content = e.message
        end
        msg
      end


      def self.export(user_agent, q=nil)
        msg = Message.new
        begin
          tmp_file = PartHandler.full_tmp_path('tool.csv') unless tmp_file

          CSV.open(tmp_file, 'wb', write_headers: true,
                   headers: IMPORT_HEADERS,
                   col_sep: SEPARATOR, encoding: ToolHandler.get_encoding(user_agent)) do |csv|
            if q.nil?
              tools= Tool.all
            else
              tools = Tool.search_for(q).all
            end

            tools.each do |tool|
              csv<<[
                  tool.nr,
                  tool.nr_display,
                  tool.resource_group_tool.nil? ? '' : tool.resource_group_tool.nr,
                  tool.part_nrs,
                  tool.mnt,
                  tool.used_days,
                  tool.rql,
                  tool.tol,
                  tool.rql_date,
                  'update'
              ]
            end
          end
          msg.result =true
          msg.content =tmp_file
        rescue => e
          msg.content =e.message
        end
        msg
      end


      def self.validate_import(file)
        tmp_file=full_tmp_path(file.file_name)
        msg=Message.new(result: true)
        CSV.open(tmp_file, 'wb', write_headers: true,
                 headers: IMPORT_HEADERS+['Error MSG'], col_sep: file.col_sep, encoding: file.encoding) do |csv|
          CSV.foreach(file.file_path, headers: file.headers, col_sep: file.col_sep, encoding: file.encoding) do |row|
            mmsg = validate_row(row)
            if mmsg.result
              csv<<row.fields
            else
              if msg.result
                msg.result=false
                msg.content = "请下载错误文件<a href='/files/#{Base64.urlsafe_encode64(tmp_file)}'>#{::File.basename(tmp_file)}</a>"
              end
              csv<<(row.fields<<mmsg.content)
            end
          end
        end
        return msg
      end

      def self.validate_row(row)
        msg = Message.new({result: true, contents: []})


        rg = ResourceGroup.find_by_nr(row['Resource Group'])
        unless rg
          msg.contents << "Resource Group:#{row['Resource Group']} 不存在"
        end
        puts '-------------------'
        puts row['Parts']

        puts '-------------------'
        row['Parts'].split(',').each do |part|
          unless Part.find_by_nr(part)
            msg.contents << "Part: #{part} 不存在"
          end
        end if row['Parts'].present?

        unless msg.result=(msg.contents.size==0)
          msg.content=msg.contents.join('/')
        end
        return msg
      end

    end
  end
end