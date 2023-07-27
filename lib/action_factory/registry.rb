# frozen_string_literal: true

require "active_support/core_ext/string/inflections"

module ActionFactory
  module Registry
    class << self
      def register(factory_name, factory_class_name)
        factories[factory_name.to_sym] = factory_class_name
      end

      def factories
        @factories ||= Hash.new { |factories, name| factories[name.to_sym] = name.to_s.classify }
      end

      def factory_class_name(factory_name)
        "#{class_name(factory_name)}Factory"
      end

      def class_name(factory_name)
        factories[factory_name.to_sym]
      end
    end
  end
end
