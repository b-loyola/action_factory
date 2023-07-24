# frozen_string_literal: true

module ActionFactory
  module Assignments
    class Attribute
      attr_reader :block

      def initialize(name, block)
        @name = name
        @block = block
      end

      def skip?(skipper)
        skipper.attribute_keys.include?(@name)
      end

      def block_args
        []
      end
    end
  end
end
