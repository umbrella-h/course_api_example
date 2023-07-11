module Api::V1
  class UserCoursesController < BaseController
    def index
      result = Enrollment::UseCases::FindCoursesByUser.new.call(userId: params[:user_id])
      return bad_request(failure_message: result.failure) unless result.success?

      render json: success_json(data: result.value!)
    end
  end
end
