module Enrollment
  module UseCases
    class QueryUserEnrollments::Validator < Frameworks::BaseValidator
      option :user_client, default: -> { ::User::Client.new }

      params do
        required(:userId).filled(:integer)
        optional(:courseId).filled(:integer)
        optional(:role).filled(:string)
      end

      rule(:userId) do
        key.failure('user not found') if user_client.find_user_by_id(id: value).nil?
      end
    end
  end
end