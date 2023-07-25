# frozen_string_literal: true

module ActionFactory
  class AssignmentCompiler

    def initialize(factory)
      @factory = factory
    end

    def compile(assignments, only: assignments.keys, except: [])
      assignments.slice(*only).except(*except).transform_values do |assignment|
        assignment.compile(@factory)
      end
    end

  end
end
