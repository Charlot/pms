module FileHandler
  module Csv
    class File<Base
      attr_accessor :encoding, :col_sep, :path, :user_agent, :headers

      def initialize (args={})
        super
        self.encoding = File.get_encoding(user_agent)
      end

      def default
        {col_sep: SEPARATOR, headers: true}
      end

    end
  end
end