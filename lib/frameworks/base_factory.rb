require 'dry-initializer'

module Frameworks
  class BaseFactory
    extend Dry::Initializer

    option :entity, default: -> {}

    def build(record)
      entity.new(record)
    end
  end
end
