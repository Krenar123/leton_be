class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  private

  # e.g., in ApplicationController (and ensure `helper_method :current_user` if needed)
  def current_user
    return @current_user if defined?(@current_user) && @current_user.present?

    # If a user already exists, use it
    if (u = User.first)
      @current_user = u
      return @current_user
    end

    # Otherwise, bootstrap a default organization and admin user
    @current_user = ActiveRecord::Base.transaction do
      org = Organization.first_or_create!(
        name:    "Leton Construction",
        industry:"Construction",
        address: "123 Main St, New York, NY",
        website: "https://leton.com"
      )

      # Use find_or_create_by! for idempotency (avoids duplicates on retries/races)
      User.find_or_create_by!(email: "john@leton.com") do |admin|
        admin.organization = org
        admin.full_name    = "John Smith"
        admin.password     = "password123" # TODO: change in production!
        admin.role         = :admin        # If enum, ensure `User.roles[:admin]` exists
        admin.phone        = "+1 234 567 8901"
        admin.address      = "123 Main St, New York, NY 10001"
        admin.position     = "Director"
        admin.department   = "Management"
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("Bootstrap admin creation failed: #{e.class}: #{e.message}")
    raise
  end


  def not_found
    render json: {
      errors: [
        { title: "Not Found", detail: "The requested resource could not be found." }
      ]
    }, status: :not_found
  end
end
