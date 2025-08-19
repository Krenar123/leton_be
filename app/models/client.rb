class Client < ApplicationRecord
  belongs_to :created_by, class_name: 'User'

  has_many :projects
  has_many :notes
  has_many :documents

  enum :status, { active: 0, inactive: 1, prospect: 2 }

  validates :company, :contact_name, presence: true
end
