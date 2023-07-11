require 'dry-initializer'

module Frameworks
  class BaseRepository
    extend Dry::Initializer

    option :factory, default: -> {}
  end
end
