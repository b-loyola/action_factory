# frozen_string_literal: true

module ActionFactory
  class AssignmentCompiler

    def initialize(factory)
      @factory = factory
    end

    def compile(assignments, only: assignments.keys, except: [])
      assignments.slice(*only).except(*except).transform_values do |assignment|
        args, block = assignment.compile(@factory)
        @factory.instance_exec(*args, &block)
      end
    end

  end
end
