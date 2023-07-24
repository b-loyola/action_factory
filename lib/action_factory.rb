# frozen_string_literal: true

require "action_factory/version"
require "action_factory/helpers"
require "action_factory/base"

module ActionFactory
  class Configuration
    attr_accessor :persist_method, :initialize_method

    def initialize
      @persist_method = :save!
      @initialize_method = :new
    end
  end

  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end
  end
end
