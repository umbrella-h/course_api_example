module User
  module Repositories
    class User < Frameworks::BaseRepository
      option :factory, default: -> { Factory::User.new }
      option :table_name, default: -> { 'users' }
      option :source, default: -> { Dataset::Base.instance }
      option :factory, default: -> { Factory::User.new }

      def find(id:)
        record = source.find(table_name: table_name, primary_hash: { id: id })
        return nil if record.nil?

        factory.build(record)
      end

      def where(name: nil, email: nil)
        query_hash = { name: name, email: email }.compact
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
