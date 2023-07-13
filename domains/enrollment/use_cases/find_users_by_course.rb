module Enrollment
  module UseCases
    class FindUsersByCourse < Frameworks::BaseUseCase
      option :enrollment_repo, default: -> { ::Enrollment::Repositories::Enrollment.new }
      option :course_client, default: -> { ::Course::Client.new }
      option :user_client, default: -> { ::User::Client.new }

      def steps(courseId:)
        courseId = courseId.to_i
        yield check_course(courseId: courseId)
        enrollments = filter_record(courseId: courseId)
        users = retrieve_users(enrollments: enrollments)

        Success(users)
      end

      private

      def check_course(courseId:)
        course = course_client.find_course_by_id(id: courseId)

        return Failure('Course not found') if course.nil?
      
        Success()
      end

      def filter_record(courseId:)
        enrollment_repo.where(courseId: courseId)
      end

      def retrieve_users(enrollments:)
        userIds = enrollments.map(&:userId)
        user_client.find_users_by_ids(ids: userIds)
      end
    end
  end
end
