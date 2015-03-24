module Printer
  class Client
    attr_accessor :printer

    def initialize(args)
      self.printer= Kernel.const_get("Printer::#{args[:code].downcase.classify}").new(args)
    end

    def gen_data
      self.printer.data_set
    end
  end
end