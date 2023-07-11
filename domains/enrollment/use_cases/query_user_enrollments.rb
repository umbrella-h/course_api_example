module Enrollment
  module UseCases
    class QueryUserEnrollments < Frameworks::BaseUseCase
      option :validator, default: -> { Enrollment::UseCases::QueryUserEnrollments::Validator.new }
      option :enrollment_repo, default: -> { ::Enrollment::Repositories::Enrollment.new }

      def steps(userId:, courseId: nil, role: nil)
        query = yield compact_params(courseId: courseId, role: role)
        validated_attributes = yield validate(attributes: query.merge(userId: userId))
        records = find_records(validated_attributes: validated_attributes)

        Success(records)
      end

      private

      def compact_params(courseId:, role:)
        query = { courseId: courseId, role: role }.compact
        return Failure('Please query by role or courseId') if query.empty?

        Success(query)
      end

      def validate(attributes:)
        result = validator.call(attributes)
        return Failure(result.errors(full: true).messages.map(&:text).join(". ")) unless result.success?

        Success(result.to_h)
      end

      def find_records(validated_attributes:)
        enrollment_repo.where(validated_attributes)
      end
    end
  end
end
