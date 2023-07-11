module Enrollment
  module Entities
    class Enrollment < Frameworks::BaseEntity
      ROLE_TYPES = %w[student teacher].freeze

      attribute :id,        Types::Integer
      attribute :userId,    Types::Integer
      attribute :courseId,  Types::Integer
      attribute :role,      Types::String.enum(*ROLE_TYPES)
    end
  end
end
