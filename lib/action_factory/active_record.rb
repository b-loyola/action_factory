# frozen_string_literal: true

require "active_support/core_ext/hash/indifferent_access"

require "action_factory/runner"

module ActionFactory
  module ActiveRecord

    class Association
      def initialize(strategy:, factory_name:, traits:, block:)
        @strategy = strategy
        @factory_name = factory_name
        @traits = traits
        @block = block
      end

      def generate(strategy)
        @block ? @block.call(runner) : runner.run(strategy)
      end

      def runner
        @runner ||= ActionFactory::Runner.new(@factory_name, *@traits, strategy: @strategy)
      end
    end

    def self.included(base)
      base.extend ClassMethods
      base.class_exec do
        before_assign_attributes :build_associations
      end
    end

    module ClassMethods
      def associations
        @associations ||= {}.with_indifferent_access
      end

      def association(name, strategy: nil, factory: name, traits: [], &block)
        associations[name] = Association.new(strategy:, factory_name: factory, traits:, block:)
      end
    end

    private

    def build_associations
      self.class.associations.except(*@attributes.keys).each do |name, association|
        associated_record = association.generate(@strategy)
        @instance.association(name.to_sym).writer(associated_record)
      end
    end

  end
end
