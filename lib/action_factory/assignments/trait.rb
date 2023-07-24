# frozen_string_literal: true

module ActionFactory
  module Assignments
    class Trait
      def initialize(name, block)
        @name = name
        @block = block
      end

      def compile(factory)
        [[factory.instance], @block]
      end
    end
  end
end
