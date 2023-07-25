# frozen_string_literal: true

module ActionFactory
  module Assignments
    class Sequence
      def initialize(block)
        @count = 0
        @block = block
      end

      def compile(factory)
        # @count += 1
        factory.instance_exec(@count += 1, &@block)
      end
    end
  end
end
