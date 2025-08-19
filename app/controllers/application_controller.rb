class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  private

  def current_user
    # In dev/test you can hardcode this or fetch by ID/email
    @current_user ||= User.first
  end

  def not_found
    render json: {
      errors: [
        { title: "Not Found", detail: "The requested resource could not be found." }
      ]
    }, status: :not_found
  end
end
