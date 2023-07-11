module Enrollment
  module UseCases
    class QueryCourseEnrollments::Validator < Frameworks::BaseValidator
      option :course_client, default: -> { ::Course::Client.new }

      params do
        required(:courseId).filled(:integer)
        optional(:userId).filled(:integer)
        optional(:role).filled(:string)
      end

      rule(:courseId) do
        key.failure('course not found') if course_client.find_course_by_id(id: value).nil?
      end
    end
  end
end