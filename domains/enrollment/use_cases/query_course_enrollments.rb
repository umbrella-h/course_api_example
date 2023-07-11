module Enrollment
  module UseCases
    class QueryCourseEnrollments < Frameworks::BaseUseCase
      option :validator, default: -> { Enrollment::UseCases::QueryCourseEnrollments::Validator.new }
      option :enrollment_repo, default: -> { ::Enrollment::Repositories::Enrollment.new }

      def steps(courseId:, userId: nil, role: nil)
        query = yield compact_params(userId: userId, role: role)
        validated_attributes = yield validate(attributes: query.merge(courseId: courseId))
        records = find_records(validated_attributes: validated_attributes)

        Success(records)
      end

      private

      def compact_params(userId:, role:)
        query = { userId: userId, role: role }.compact
        return Failure('Please query by role or userId') if query.empty?

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
