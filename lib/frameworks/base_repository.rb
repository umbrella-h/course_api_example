require 'dry-initializer'

module Frameworks
  class BaseRepository
    extend Dry::Initializer

    option :factory, default: -> {}

    def find(id:)
      record = source.find(table_name: table_name, primary_hash: { id: id })
      return nil if record.nil?

      factory.build(record)
    end
  end
end
