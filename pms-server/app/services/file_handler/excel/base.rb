module FileHandler
  module Excel
    class Base<FileHandler::Base
      DEFAULT_ERROR_FORMAT= {:style => :bold, :color => Axlsx::Color.new(:rgb => 'FF0000'), :b => true}

      #@file = nil

      #def initialize(file_path)
      #  @file = Roo::Excel.new(file_path)
      #end
    end
  end
end