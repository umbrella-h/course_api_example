module Course
  module Entities
    class Course < Frameworks::BaseEntity
      attribute :id,      Types::Integer
      attribute :name,    Types::String
    end
  end
end
