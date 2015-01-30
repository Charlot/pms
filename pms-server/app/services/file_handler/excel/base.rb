module FileHandler
  module Excel
    class Base<FileHandler::Base
      DEFAULT_ERROR_FORMAT= {:style => :bold, :color => Axlsx::Color.new(:rgb => 'FF0000'), :b => true}
    end
  end
end