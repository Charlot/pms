require 'csv'
module FileHandler
  module CSV
    IMPORT_HEADERS=['Machine Nr','W1','T1','T2','S1','S2']
    INVALID_CSV_HEADERS=IMPORT_HEADERS<<'Error MSG'

    def self.import(file)
      msg = Message.new
      begin
        validate_msg = validate_import(file)
        if validate_msg.result
          MachineCombination.transaction do
            machine = Machine.find_by_nr(row['Machine Nr'])
            machine_scope = MachineScope.new
            ['W1','T1','T2','S1','S2'].each{|header|
              if row[header].present?
                part = Part.find_by_nr(row[header])
                machine_scope.send("#{header.downcase}=",part.nr)
              end
            }
            machine_scope.machine = machine
            machine_scope.save
          end
          msg.result = true
          msg.content = 'Machine Scope 上传成功'
        else
          msg.result = false
          msg.content = validate_msg.content
        end
      rescue => e
        msg.content = e.message
      end
      return msg
    end

    def self.validate_import(file)
      return msg
    end

    def self.validate_row(file)
      msg = Message.new(contents:[])

      machine = Machine.find_by_nr(row['Machine Nr'])
      unless machine.present?
        msg.contents << "Machine Nr: #{row['Machine Nr']} 不存在！"
      end

      ['W1','T1','T2','S1','S2'].each{|header|
        if row[header].present?
          unless Part.find_by_nr(row[header])
            msg.contents << "#{header}: #{row[header]} 未找到！"
          end
        end
      }

      unless msg.result = (msg.contents.size == 0)
        msg.content=msg.contents.join('/')
      end
      return msg
    end
  end
end