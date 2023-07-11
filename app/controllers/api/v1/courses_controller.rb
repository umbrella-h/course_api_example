module Api::V1
  class CoursesController < BaseController
    def show
      result = Course::UseCases::FindCourseById.new.call(id: params[:id])
      return bad_request(failure_message: result.failure) unless result.success?

      render json: success_json(data: result.value!)
    end
  end
end
