module Api::V1
  class UserEnrollmentsController < BaseController
    def index
      result = Enrollment::UseCases::QueryUserEnrollments.new.call(userId: params[:user_id], courseId: params[:courseId], role: params[:role])
      return bad_request(failure_message: result.failure) unless result.success?

      render json: success_json(data: result.value!)
    end
  end
end
