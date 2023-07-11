module Enrollment
  module UseCases
    class DeleteEnrollmentById < Frameworks::BaseUseCase
      option :enrollment_repo, default: -> { ::Enrollment::Repositories::Enrollment.new }

      def steps(id:)
        yield delete_record(id: id.to_i)

        Success()
      end

      private

      def delete_record(id:)
        enrollment = enrollment_repo.find(id: id)

        return Failure('Enrollment not found') if enrollment.nil?

        enrollment_repo.delete(id: id)

        Success()
      end
    end
  end
end
