# frozen_string_literal: true

require "action_factory/registry"

module ActionFactory
  class FactoryFinder
    FactoryNotFound = Class.new(StandardError)

    class << self
      def factory_class_for(name)
        new(name).factory_class
      end
    end

    def initialize(name)
      @name = name
    end

    def factory_class
      factory_class_name = Registry.factory_class_name_for(@name)
      factory_class_name.constantize
    rescue NameError
      raise FactoryNotFound, "Factory with class name #{factory_class_name.inspect} not found"
    end
  end
end
