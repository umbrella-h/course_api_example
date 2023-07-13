module Enrollment
  module UseCases
    class FindCoursesByUser < Frameworks::BaseUseCase
      option :enrollment_repo, default: -> { ::Enrollment::Repositories::Enrollment.new }
      option :course_client, default: -> { ::Course::Client.new }
      option :user_client, default: -> { ::User::Client.new }

      def steps(userId:)
        userId = userId.to_i
        yield check_user(userId: userId)
        enrollments = filter_record(userId: userId)
        users = retrieve_courses(enrollments: enrollments)

        Success(users)
      end

      private

      def check_user(userId:)
        user = user_client.find_user_by_id(id: userId)

        return Failure('User not found') if user.nil?
      
        Success()
      end

      def filter_record(userId:)
        enrollment_repo.where(userId: userId)
      end

      def retrieve_courses(enrollments:)
        courseIds = enrollments.map(&:courseId)
        course_client.find_courses_by_ids(ids: courseIds)
      end
    end
  end
end
