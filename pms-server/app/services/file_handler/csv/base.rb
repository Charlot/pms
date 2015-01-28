module FileHandler
  module Csv
    class Base<FileHandler::Base
      SEPARATOR=$csv_separator

      def self.get_encoding(user_agent)
        os=System::Base.os_by_user_agent(user_agent)
        case os
          when 'windows'
            return 'GB18030:UTF-8'
          when 'linux', 'macintosh'
            return 'UTF-8:UTF-8'
          else
            return 'UTF-8:UTF-8'
        end
      end
    end
  end
end