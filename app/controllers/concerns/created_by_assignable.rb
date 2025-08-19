module CreatedByAssignable
  extend ActiveSupport::Concern

  private

  def assign_created_by(resource)
    puts
    puts resource
    puts current_user
    puts
    resource.created_by = current_user if resource.respond_to?(:created_by=)
  end
end
