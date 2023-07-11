module Course
  module UseCases
    class FindCourseById < Frameworks::BaseUseCase
      option :course_repo, default: -> { ::Course::Repositories::Course.new }

      def steps(id:)
        course = yield find_record(id: id.to_i)

        Success(course)
      end

      private

      def find_record(id:)
        course = course_repo.find(id: id)

        return Failure('Course not found') if course.nil?

        Success(course)
      end
    end
  end
end
