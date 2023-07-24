# frozen_string_literal: true

module ActionFactory
  class AttributeCompiler

    Skipper = Struct.new(:traits, :attribute_keys, keyword_init: true) do
      def trait?(trait)
        (traits.map(&:to_s) || []).include?(trait.to_s)
      end

      def attribute?(attribute)
        (attribute_keys.map(&:to_s) || []).include?(attribute.to_s)
      end
    end

    def initialize(assignments, traits, attribute_keys)
      @assignments = assignments
      @skipper = Skipper.new(traits:, attribute_keys:)
    end

    def compile(factory)
      @assignments.each_with_object({}) do |(name, assignment), attributes|
        next if assignment.skip?(@skipper)

        attributes[name] = factory.instance_exec(*assignment.block_args, &assignment.block)
      end
    end

  end
end
