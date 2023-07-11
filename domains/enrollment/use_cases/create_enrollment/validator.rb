module Enrollment
  module UseCases
    class CreateEnrollment::Validator < Frameworks::BaseValidator
      option :enrollment_repo, default: -> { ::Enrollment::Repositories::Enrollment.new }
      option :user_client, default: -> { ::User::Client.new }
      option :course_client, default: -> { ::Course::Client.new }
      option :role_types, default: -> { ::Enrollment::Entities::Enrollment::ROLE_TYPES }

      params do
        required(:userId).filled(:integer)
        required(:courseId).filled(:integer)
        required(:role).filled(:string)
      end

      rule(:userId, :courseId) do
        key.failure("#{values[:userId]} has been enrolled in courseId #{values[:courseId]}") if enrollment_repo.where(userId: values[:userId], courseId: values[:courseId]).any?
      end

      rule(:userId) do
        key.failure('User not found') if user_client.find_user_by_id(id: value).nil?
      end

      rule(:courseId) do
        key.failure('Course not found') if course_client.find_course_by_id(id: value).nil?
      end

      rule(:role) do
        key.failure("should be #{role_types.join(' or ')}") unless role_types.include?(value)
      end
    end
  end
end
