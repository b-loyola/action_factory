# frozen_string_literal: true

# require "action_factory/factory_finder"
require "action_factory/runner"

module ActionFactory
  module Helpers
    def build(factory_name, *traits, **attributes)
      ActionFactory::Runner.run(factory_name, *traits, strategy: :build, **attributes)
    end

    def create(factory_name, *traits, **attributes)
      ActionFactory::Runner.run(factory_name, *traits, strategy: :create, **attributes)
    end
  end
end
