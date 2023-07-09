class HomepagesController < ApplicationController
  def index
    render json: { status: 'success', data: { homepage_status: 'up' } }
  end
end
