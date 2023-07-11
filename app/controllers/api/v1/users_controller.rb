module Api::V1
  class UsersController < BaseController
    before_action :authenticate, only: %i[create update destroy]

    def index
      result = User::UseCases::QueryUser.new.call(name: params[:name], email: params[:email])
      return bad_request(failure_message: result.failure) unless result.success?

      render json: success_json(data: result.value!)
    end

    def show
      result = User::UseCases::FindUserById.new.call(id: params[:id])
      return bad_request(failure_message: result.failure) unless result.success?

      render json: success_json(data: result.value!)
    end

    def create
      result = User::UseCases::CreateUser.new.call(name: params[:name], email: params[:email])
      return bad_request(failure_message: result.failure) unless result.success?

      render json: success_json(data: result.value!)
    end

    def update
      result = User::UseCases::UpdateUserById.new.call(id: params[:id], name: params[:name], email: params[:email])
      return bad_request(failure_message: result.failure) unless result.success?

      render json: success_json(data: result.value!)
    end

    def destroy
      result = User::UseCases::DeleteUserById.new.call(id: params[:id])
      return bad_request(failure_message: result.failure) unless result.success?

      render json: success_json(data: result.value!)
    end
  end
end
