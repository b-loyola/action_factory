# frozen_string_literal: true

module ActionFactory
  module Assignments
    class Sequence
      attr_reader :block

      def initialize(name, block)
        @name = name
        @count = 0
        @block = block
      end

      def skip?(skipper)
        skipper.attribute_keys.include?(@name)
      end

      def block_args
        @count += 1
        [@count]
      end
    end
  end
end
