# frozen_string_literal: true

require "active_support/core_ext/hash/indifferent_access"
require "active_support/core_ext/module/delegation"
require "active_support/core_ext/object/deep_dup"

require "active_model/callbacks"

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

      def register(factory_name: nil, class_name: nil)
        raise ArgumentError, 'factory_name or class_name required' unless factory_name || class_name

        Registry.register(factory_class_name: self.name, factory_name: factory_name, class_name: class_name)
      end

      def class_name
        Registry.class_name_for(self.name)
      end

      def klass
        @klass ||= class_name.constantize
      rescue NameError
        message = "Class with name #{class_name.inspect} not found, " \
                  "please use `register` if you need to configure a custom class name"
        raise ClassNotFound, message
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
        assignments[:attributes][name] = ActionFactory::Assignments::Attribute.new(block)
      end

      def sequence(name, &block)
        assignments[:attributes][name] = ActionFactory::Assignments::Sequence.new(block)
      end

      def trait(name, &block)
        assignments[:traits][name] = ActionFactory::Assignments::Trait.new(block)
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

    attr_reader :traits, :attributes

    def initialize(*traits, **attributes)
      raise "cannot initialize base class" if self.class == ActionFactory::Base

      @traits = traits
      @attributes = attributes
    end

    def run(strategy)
      @strategy = strategy
      public_send(@strategy)
    end

    def build
      instance
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
      @factory_attributes ||= assignment_compiler.compile(assignments[:attributes], except: @attributes.keys)
    end

    def instance
      @instance ||= build_instance_with_callbacks
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
      return instance.instance_exec(self, &creator) if creator

      instance.public_send(ActionFactory.configuration.persist_method)
    end

    def assign_attributes
      attribute_assigner.assign(@attributes)
      attribute_assigner.assign(factory_attributes)
      assignment_compiler.compile(assignments[:traits], only: @traits)
    end

    def assignment_compiler
      @assignment_compiler ||= AssignmentCompiler.new(self)
    end

    def attribute_assigner
      @attribute_assigner ||= AttributeAssigner.new(instance)
    end
  end
end
