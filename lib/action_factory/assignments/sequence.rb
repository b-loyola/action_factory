# frozen_string_literal: true

module ActionFactory
  module Assignments
    class Sequence
      def initialize(name, block)
        @name = name
        @count = 0
        @block = block
      end

      def compile(factory)
        @count += 1
        [[@count], @block]
      end
    end
  end
end
