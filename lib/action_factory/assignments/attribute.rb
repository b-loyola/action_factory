# frozen_string_literal: true

module ActionFactory
  module Assignments
    class Attribute
      def initialize(name, block)
        @name = name
        @block = block
      end

      def compile(factory)
        [[], @block]
      end
    end
  end
end
