module User
  module Entities
    class User < Frameworks::BaseEntity
      attribute :id,    Types::Integer
      attribute :name,  Types::String
      attribute :email, Types::String
    end
  end
end
