module Api::V1
  class CourseUsersController < BaseController
    def index
      result = Enrollment::UseCases::FindUsersByCourse.new.call(courseId: params[:course_id])
      return bad_request(failure_message: result.failure) unless result.success?

      render json: success_json(data: result.value!)
    end
  end
end
