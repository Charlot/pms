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

    end
  end
end