module Enrollment
  module Repositories
    class Enrollment < Frameworks::BaseRepository
      option :factory, default: -> { Factory::Enrollment.new }
      option :table_name, default: -> { 'enrollments' }
      option :source, default: -> { Dataset::Base.instance }
      option :factory, default: -> { Factory::Enrollment.new }

      def where(userId: nil, courseId: nil, role: nil)
        query_hash = { userId: userId, courseId: courseId, role: role }.compact
        records = source.where(table_name: table_name, query_hash: query_hash)

        records.map do |record|
          factory.build(record)
        end
      end

      def create(attributes:)
        id = (last_record_id || 0) + 1
        source.create(table_name: table_name, primary_hash: { id: id }, attributes: attributes)
      end

      def update(id:, attributes:)
        source.update(table_name: table_name, primary_hash: { id: id }, attributes: attributes)
      end

      def delete(id:)
        source.delete(table_name: table_name, primary_hash: { id: id })        
      end

      def all
        records = source.all(table_name: table_name)

        records.map do |record|
          factory.build(record)
        end
      end

      private

      def last_record_id
        all.map { |record| record[:id] }.max
      end
    end
  end
end
