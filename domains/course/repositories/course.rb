module Course
  module Repositories
    class Course < Frameworks::BaseRepository
      option :factory, default: -> { Factory::Course.new }
      option :table_name, default: -> { 'courses' }
      option :source, default: -> { Dataset::Base.instance }
      option :factory, default: -> { Factory::Course.new }

      def where_by_ids(ids:)
        records = source.where(table_name: table_name, query_hash: { id: ids })
        records.map do |record|
          factory.build(record)
        end
      end
    end
  end
end
