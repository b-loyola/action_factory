# frozen_string_literal: true

module ActionFactory
  module Assignments
    class Sequence
      attr_reader :block, :count

      def initialize(block)
        @block = block
        @count = 0
      end

      def compile(factory)
        factory.instance_exec(@count += 1, &@block)
      end

      def ==(other)
        other.is_a?(self.class) && other.block == @block && other.count == @count
      end
    end
  end
end
