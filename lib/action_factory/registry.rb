# frozen_string_literal: true

require "active_support/core_ext/string/inflections"

module ActionFactory
  class Registry
    class << self
      delegate :register, :factory_class_name_for, :class_name_for, to: :instance

      def instance
        @instance ||= new
      end

      def clear
        @instance = nil
      end
    end

    def initialize
      @class_name_by_factory_class_name = Hash.new do |class_names, factory_class_name|
        class_names[factory_class_name.to_s] = factory_class_name.delete_suffix("Factory")
      end
      @class_name_by_symbol = Hash.new do |class_names, symbol|
        class_names[symbol.to_sym] = symbol.to_s.classify
      end
      @factories_by_class_name = Hash.new do |factories, class_name|
        factories[class_name.to_s] = "#{class_name}Factory"
      end
    end

    def register(factory_class_name:, factory_name: nil, class_name: nil)
      class_name ||= factory_class_name.to_s.chomp("Factory")
      factory_name ||= class_name.underscore
      @class_name_by_factory_class_name[factory_class_name.to_s] = class_name
      @class_name_by_symbol[factory_name.to_sym] = class_name
      @factories_by_class_name[class_name.to_s] = factory_class_name
    end

    def factory_class_name_for(name)
      case name
      when Symbol
        # Presume that the symbol is a factory name
        @factories_by_class_name[class_name_for(name)]
      when Class, String
        # Presume that classes and strings are a model classes
        @factories_by_class_name[name.to_s]
      else
        raise ArgumentError, "Invalid argument type #{name.class}"
      end
    end

    def class_name_for(name)
      case name
      when Symbol
        # Presume that symbols are factory names
        @class_name_by_symbol[name]
      when String, Class
        # Presume that strings and classes are for factory class names
        @class_name_by_factory_class_name[name.to_s]
      else
        raise ArgumentError, "Invalid argument type #{name.class}"
      end
    end

  end
end
