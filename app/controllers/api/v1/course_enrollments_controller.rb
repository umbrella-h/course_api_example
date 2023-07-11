module Api::V1
  class CourseEnrollmentsController < BaseController
    def index
      result = Enrollment::UseCases::QueryCourseEnrollments.new.call(courseId: params[:course_id], userId: params[:userId], role: params[:role])
      return bad_request(failure_message: result.failure) unless result.success?

      render json: success_json(data: result.value!)
    end
  end
end
