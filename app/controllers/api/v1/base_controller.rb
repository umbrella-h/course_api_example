module Api::V1
  class BaseController < ApplicationController
    private

    def success_json(data: nil)
      { status: 'success', data: data || {} }
    end

    def failed_json(code:, message:)
      { status: 'failed', error: { code: code, message: message } }
    end

    def bad_request(failure_message:)
      render json: failed_json(code: 400, message: "Bad Request: #{failure_message}")
    end
  end
end
