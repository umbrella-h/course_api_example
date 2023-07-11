module Course
  module Repositories::Factory
    class Course < Frameworks::BaseFactory
      option :entity, default: -> { Entities::Course }
    end
  end
end
