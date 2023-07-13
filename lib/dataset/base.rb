require 'singleton'
require 'yaml'
require 'active_support/core_ext/hash'

module Dataset
  class Base
    include Singleton

    attr_reader :tables

    def set_up(seed_paths: Dir[Rails.root.join('lib/dataset/default_seeds/*.yml')])
      @tables = {}
      seed_paths.each do |file_path|
        data = YAML.load_file(file_path).deep_symbolize_keys
        @tables.merge!(data)
      end
    end

    def clean_up
      @tables = {}
    end

    def where(table_name:, query_hash:)
      check_for_restart
      records_with_index = where_with_index(table_name: table_name, query_hash: query_hash)
      records_with_index.map { |record_with_index| record_with_index[:record] }
    end

    def find(table_name:, primary_hash:)
      check_for_restart
      records = where(table_name: table_name, query_hash: primary_hash)
      raise DataManipulationError, 'Found >1 records by primary keys' if records.size > 1

      records.first
    end

    def all(table_name:)
      check_for_restart
      @tables[table_name.to_sym]
    end

    def where_with_index(table_name:, query_hash:)
      check_for_restart
      # TODO: Shall I check query value type here?
      records_with_index = []
      @tables[table_name.to_sym].each_with_index do |record, index|
        judgements = query_hash.map do |k, v|
          next false if record[k].nil?

          if v.kind_of?(Array)
            v.include?(record[k])
          else
            record[k] == v
          end
        end.uniq
        records_with_index.push({ index: index, record: record }) if judgements == [true]
      end
      records_with_index
    end

    def find_with_index(table_name:, primary_hash:)
      check_for_restart
      records_with_index = where_with_index(table_name: table_name, query_hash: primary_hash)
      raise DataManipulationError, 'Found >1 records by primary keys' if records_with_index.size > 1

      records_with_index.first
    end

    def update(table_name:, primary_hash:, attributes:)
      check_for_restart
      record = find(table_name: table_name, primary_hash: primary_hash)
      raise DataManipulationError, 'Record not found' if record.nil?

      attributes.each do |k, v|
        record[k] = v
      end
      record
    end

    def create(table_name:, primary_hash:, attributes:)
      check_for_restart
      record = find(table_name: table_name, primary_hash: primary_hash)
      raise DataManipulationError, 'Record exists' unless record.nil?

      new_record = primary_hash.merge(attributes)
      @tables[table_name.to_sym].push(new_record)
      new_record
    end

    def delete(table_name:, primary_hash:)
      check_for_restart
      record_with_index = find_with_index(table_name: table_name, primary_hash: primary_hash)
      raise DataManipulationError, 'Record not found' if record_with_index.nil?

      @tables[table_name.to_sym].delete_at(record_with_index[:index])
      record_with_index[:record]
    end

    private

    def check_for_restart
      # TODO: Design an elegant implementation
      raise DataNotSetUp, 'Dataset is not set up. Please restart Rails app.' if @tables.nil?
    end
  end

  class DataManipulationError < StandardError
  end

  class DataNotSetUp < StandardError
  end
end
