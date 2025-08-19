class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  before_validation :generate_ref_if_supported, on: :create

  private

  def generate_ref_if_supported
    return unless self.class.column_names.include?("ref")
    self.ref ||= SecureRandom.hex(24)
  end
end
