# frozen_string_literal: true

module ActionFactory
  class AttributeAssigner

    def initialize(instance)
      @instance = instance
    end

    def assign(attributes)
      attributes.each do |name, value|
        @instance.public_send("#{name}=", value)
      end
    end

  end
end
