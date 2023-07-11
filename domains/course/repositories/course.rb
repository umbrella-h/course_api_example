module Course
  module Repositories
    class Course < Frameworks::BaseRepository
      option :factory, default: -> { Factory::Course.new }
      option :table_name, default: -> { 'courses' }
      option :source, default: -> { Dataset::Base.instance }
      option :factory, default: -> { Factory::Course.new }
    end
  end
end
