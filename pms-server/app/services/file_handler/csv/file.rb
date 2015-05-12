module FileHandler
  module Csv
    class File<Base
      attr_accessor :encoding, :col_sep, :file_path, :file_name, :user_agent, :headers

      def initialize (args={})
        super
        self.encoding = File.get_encoding(user_agent)
      end

      def default
        {col_sep: ';', headers: true}
      end
      
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