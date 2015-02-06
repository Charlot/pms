module Pms
  module SubclassFactory
    def self.included(base) 
      base.extend ClassMethods
    end 

    module ClassMethods
      def get_subclass(class_name)
        klass = nil
        begin
          klass = class_name.to_s.classify.constantize
        rescue
          # invalid class name
        end
        unless subclasses.include? klass
          klass = nil
        end
        klass
      end

      # Returns an instance of the given subclass name
      def new_subclass_instance(class_name, *args)
        klass = get_subclass(class_name)
        if klass
          klass.new(*args)
        end
      end
    end
  end
end
