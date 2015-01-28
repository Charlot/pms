module FileHandler
  module Csv
    class File<Base
      attr_accessor :encoding, :col_sep, :path, :user_agent

      def initialize (args={})
        super
        self.encoding = File.get_encoding(user_agent)
      end

      def default
        {col_sep: SEPARATOR}
      end

    end
  end
end