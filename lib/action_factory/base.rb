# frozen_string_literal: true

require "action_factory/assignment_compiler"
require "action_factory/attribute_assigner"
require "action_factory/assignments"

module ActionFactory
  class Base
    extend ActiveModel::Callbacks

    define_model_callbacks :initialize, only: [:after]
    define_model_callbacks :assign_attributes, :create

    ClassNotFound = Class.new(StandardError)

    class << self
      attr_reader :initializer, :creator

      def factory(name)
        Registry.register(name, self.name)
      end

      def class_name(name)
        @klass_name = name
      end

      def klass_name
        @klass_name ||= name.delete_suffix('Factory')
      end

      def klass
        @klass ||= klass_name.constantize
      rescue NameError
        raise ClassNotFound, "Class with name #{class_name.inspect} not found"
      end

      def to_initialize(&block)
        raise ArgumentError, 'Block required' unless block_given?
        @initializer = block
      end

      def to_create(&block)
        raise ArgumentError, 'Block required' unless block_given?
        @creator = block
      end

      def attribute(name, &block)
        assignments[:attributes][name] = ActionFactory::Assignments::Attribute.new(name, block)
      end

      def sequence(name, &block)
        assignments[:attributes][name] = ActionFactory::Assignments::Sequence.new(name, block)
      end

      def trait(name, &block)
        assignments[:traits][name] = ActionFactory::Assignments::Trait.new(name, block)
      end

      def assignments
        @assignments ||= begin
          if self.superclass.respond_to?(:assignments)
            self.superclass.assignments.deep_dup
          else
            ActiveSupport::HashWithIndifferentAccess.new { |hash, key| hash[key] = {}.with_indifferent_access }
          end
        end
      end
    end

    delegate :initializer, :creator, :klass, :assignments, to: :class

    attr_reader :traits, :attributes, :instance

    def initialize(*traits, **attributes)
      @traits = traits
      @attributes = attributes
      @instance = build_instance_with_callbacks
    end

    def run(strategy)
      @strategy = strategy
      public_send(@strategy)
    end

    def build
      run_callbacks :assign_attributes do
        assign_attributes
      end
      instance
    end

    def create
      build
      run_callbacks :create do
        persist_instance
      end
      instance
    end

    def factory_attributes
      @factory_attributes ||= AssignmentCompiler.new(assignments[:attributes]).compile(factory: self, except: @attributes.keys)
    end

    private

    def build_instance_with_callbacks
      run_callbacks :initialize do
        build_instance
      end
    end

    def build_instance
      return klass.class_exec(self, &initializer) if initializer

      klass.public_send(ActionFactory.configuration.initialize_method)
    end

    def persist_instance
      return @instance.instance_exec(self, &creator) if creator

      @instance.public_send(ActionFactory.configuration.persist_method)
    end

    def assign_attributes
      attribute_assigner.assign(@attributes)
      attribute_assigner.assign(factory_attributes)
      TraitCompiler.new(assignments[:traits]).compile(factory: self, only: @traits)
    end

    def attribute_assigner
      @attribute_assigner ||= AttributeAssigner.new(instance)
    end
  end
end
