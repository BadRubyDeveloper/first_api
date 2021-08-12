class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  private

  def render_not_found
    render json: { message: "Record not found" }, status: 404
  end
end
