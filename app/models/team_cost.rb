class TeamCost < ApplicationRecord
  belongs_to :project
  belongs_to :user
  belongs_to :created_by, class_name: 'User'

  validates :hours_worked, :hourly_rate, :total_cost, presence: true

  
end
