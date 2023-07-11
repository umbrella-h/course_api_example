module Enrollment
  module Repositories::Factory
    class Enrollment < Frameworks::BaseFactory
      option :entity, default: -> { Entities::Enrollment }
    end
  end
end
