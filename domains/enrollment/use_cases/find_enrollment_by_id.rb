module Enrollment
  module UseCases
    class FindEnrollmentById < Frameworks::BaseUseCase
      option :enrollment_repo, default: -> { ::Enrollment::Repositories::Enrollment.new }

      def steps(id:)
        enrollment = yield find_record(id: id.to_i)

        Success(enrollment)
      end

      private

      def find_record(id:)
        enrollment = enrollment_repo.find(id: id)

        return Failure('Enrollment not found') if enrollment.nil?

        Success(enrollment)
      end
    end
  end
end
