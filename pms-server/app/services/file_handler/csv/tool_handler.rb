require 'csv'
module FileHandler
  module Csv
    class ToolHandler<Base
      IMPORT_HEADERS=['Nr','Resource Group','Part','MNT','Used Days','Rql','Tol','Rql Date']
      INVALID_CSV_HEADERS=IMPORT_HEADERS<<'Error MSG'

      def self.import(file)
        msg = Message.new
        begin
          validate_msg = validate_import(file)
          if validate_msg.result
            CSV.foreach(file.file_path,headers: file.headers,col_sep: file.col_sep,encoding: file.encoding) do |row|
              row.strip
              Tool.transaction do
                rg = ResourceGroup.find_by_nr(row['Resource Group'])
                part = Part.find_by_nr(row['Part'])
                if tool = Tool.find_by_nr(row['Nr'])
                  #update
                  tool.update({
                                  resource_group_id:rg.id,
                                  part_id:part.id,
                                  mnt:row['MNT'],
                                  used_days:row['Used Days'],
                                  rql:row['Rql'],
                                  tol:row['Tol'],
                                  rql_date:row['Rql Date']
                              })
                else
                  #create
                  tool = Tool.new({
                                      nr:row['Nr'],
                                      resource_group_id:rg.id,
                                      part_id:part.id,
                                      mnt:row['MNT'],
                                      used_days:row['Used Days'],
                                      rql:row['Rql'],
                                      tol:row['Tol'],
                                      rql_date:row['Rql Date']
                                  })
                  tool.save
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

      def self.validate_import(file)
        tmp_file=full_tmp_path(file.file_name)
        msg=Message.new(result: true)
        CSV.open(tmp_file, 'wb', write_headers: true,
                 headers: INVALID_CSV_HEADERS, col_sep: file.col_sep, encoding: file.encoding) do |csv|
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
        msg = Message.new({result:true,contents:[]})
        rg = ResourceGroup.find_by_nr(row['Resource Group'])
        unless rg
          msg.contents << "Resource Group:#{row['Resource Group']} 不存在"
        end

        unless Part.find_by_nr(row['Part'])
          msg.contents << "Part: #{row['Part']} 不存在"
        end

        unless msg.result=(msg.contents.size==0)
          msg.content=msg.contents.join('/')
        end
        return msg
      end

    end
  end
end