# frozen_string_literal: true

module ActionFactory
  module Assignments
    class Attribute
      def initialize(block)
        @block = block
      end

      def compile(factory)
        factory.instance_exec(&@block)
      end
    end
  end
end
