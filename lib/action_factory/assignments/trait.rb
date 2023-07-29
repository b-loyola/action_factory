# frozen_string_literal: true

module ActionFactory
  module Assignments
    class Trait
      attr_reader :block

      def initialize(block)
        @block = block
      end

      def compile(factory)
        factory.instance_exec(factory.instance, &@block)
      end

      def ==(other)
        other.is_a?(self.class) && other.block == @block
      end
    end
  end
end
