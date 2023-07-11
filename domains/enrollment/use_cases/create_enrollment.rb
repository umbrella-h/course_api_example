module Enrollment
  module UseCases
    class CreateEnrollment < Frameworks::BaseUseCase
      option :validator, default: -> { Enrollment::UseCases::CreateEnrollment::Validator.new }
      option :enrollment_repo, default: -> { ::Enrollment::Repositories::Enrollment.new }

      def steps(userId:, courseId:, role:)
        validated_attributes = yield validate(attributes: { userId: userId, courseId: courseId, role: role })
        create_record(validated_attributes: validated_attributes)

        Success()
      end

      private

      def validate(attributes:)
        result = validator.call(attributes)
        return Failure(result.errors(full: true).messages.map(&:text).join('. ')) unless result.success?

        Success(result.to_h)
      end

      def create_record(validated_attributes:)
        enrollment_repo.create(attributes: validated_attributes)
      end
    end
  end
end
