# frozen_string_literal: true

module ActionFactory
  class AssignmentCompiler

    def initialize(factory)
      @factory = factory
    end

    def compile(assignments, only: nil, except: [])
      if only.present? && except.present?
        raise ArgumentError, "Cannot use both 'only' and 'except' options"
      end

      assignments = assignments.slice(*only) unless only.nil?

      assignments.except(*except).transform_values do |assignment|
        assignment.compile(@factory)
      end
    end

  end
end
