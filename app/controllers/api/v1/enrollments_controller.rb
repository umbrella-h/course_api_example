module Api::V1
  class EnrollmentsController < BaseController
    def show
      result = Enrollment::UseCases::FindEnrollmentById.new.call(id: params[:id])
      return bad_request(failure_message: result.failure) unless result.success?

      render json: success_json(data: result.value!)
    end

    def create
      result = Enrollment::UseCases::CreateEnrollment.new.call(userId: params[:userId], courseId: params[:courseId], role: params[:role])
      return bad_request(failure_message: result.failure) unless result.success?

      render json: success_json(data: result.value!)
    end

    def destroy
      result = Enrollment::UseCases::DeleteEnrollmentById.new.call(id: params[:id])
      return bad_request(failure_message: result.failure) unless result.success?

      render json: success_json(data: result.value!)
    end
  end
end
