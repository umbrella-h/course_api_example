module User
  module Repositories::Factory
    class User < Frameworks::BaseFactory
      option :entity, default: -> { Entities::User }
    end
  end
end
