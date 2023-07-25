# frozen_string_literal: true

module ActionFactory
  module Assignments
    class Trait
      def initialize(block)
        @block = block
      end

      def compile(factory)
        factory.instance_exec(factory.instance, &@block)
      end
    end
  end
end
