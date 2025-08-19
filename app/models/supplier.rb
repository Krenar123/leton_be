class Supplier < ApplicationRecord
  belongs_to :created_by, class_name: 'User'

  has_many :documents

  enum :status, { active: 0, inactive: 1 }

  

  validates :company, :contact_name, presence: true
end
