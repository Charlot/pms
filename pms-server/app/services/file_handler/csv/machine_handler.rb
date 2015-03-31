require 'csv'
module FileHandler
  module Csv
    class MachineHandler<Base
      IMPORT_HEADERS=['Nr', 'Name', 'Description', 'Resource Group', 'IP']
      INVALID_CSV_HEADERS=IMPORT_HEADERS<<'Error MSG'

      def self.import(file)
        msg = Message.new
        begin
          validate_msg = validate_import(file)
          if validate_msg.result
            Machine.transaction do
              CSV.foreach(file.file_path, headers: file.headers, col_sep: file.col_sep, encoding: file.encoding) do |row|
                resource_group = ResourceGroup.find_by_nr(row['Resource Group'])
                machine = Machine.find_by_name(row['Name'])
                if machine
                  machine.update({name: row['Name'], description: row['Description'], resource_group_id: resource_group.id, ip: row['IP']})
                else
                  machine = Machine.new({nr: row['Nr'], name: row['Name'], description: row['Description'], resource_group_id: resource_group.id, ip: row['IP']})
                  machine.save
                  #create default scope
                  machine_scope = MachineScope.new({w1: 1, t1: 1, t2: 1, s1: 1, s2: 1, machine_id: machine.id})
                  machine_scope.save
                end
              end
            end
            msg.result = true
            msg.content = 'Machine 上传成功'
          else
            msg.result = false
            msg.content = validate_msg.content
          end
        rescue => e
          puts e.backtrace
          msg.content = e.message
        end
        return msg
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
        msg = Message.new(contents: [])
        unless ResourceGroup.find_by_nr(row['Resource Group'])
          msg.contents << "Resource Group:#{row['Resource Group']}不存在"
        end

        unless Machine.find_by_id(row['Machine Nr']).nil?
          msg.contents << "IP: #{row['IP']}已经存在"
        end

        unless msg.result=(msg.contents.size==0)
          msg.content=msg.contents.join('/')
        end
        return msg
      end
    end
  end
end
