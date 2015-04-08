module Printer
  class Base
    attr_accessor :id, :data_set, :target_ids, :head, :body, :foot

    def initialize(args=nil)
      self.data_set=[]
      self.id=args[:id]
      generate_data(args)
    end
  end
end