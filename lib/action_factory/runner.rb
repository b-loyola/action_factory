# frozen_string_literal: true

require "action_factory/factory_finder"

module ActionFactory
  class Runner
    class << self
      def run(...)
        new(...).run
      end
    end

    attr_reader :factory, :factory_name, :strategy
    delegate :traits, :attributes, to: :factory

    def initialize(factory_name, *traits, strategy: nil, **attributes)
      @factory_name = factory_name
      @strategy = strategy
      factory_class = FactoryFinder.factory_class_for(@factory_name)
      @factory = factory_class.new(*traits, **attributes)
    end

    def run(strategy = nil)
      @factory.run(strategy || @strategy)
    end
  end
end
