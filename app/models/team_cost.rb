# app/models/team_cost.rb
class TeamCost < ApplicationRecord
  belongs_to :project
  belongs_to :user
  belongs_to :created_by, class_name: 'User'

  validates :work_date, :hours_worked, presence: true
  validates :hours_worked, numericality: { greater_than: 0 }
  validates :hourly_rate, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  # Snapshot hourly_rate from user if not provided
  before_validation :default_hourly_rate_from_user
  # Always compute total_cost
  before_save :compute_total_cost

  scope :for_project, ->(project_id) { where(project_id:) }
  scope :between, ->(from, to) do
    return all if from.blank? && to.blank?
    s = all
    s = s.where('work_date >= ?', from) if from.present?
    s = s.where('work_date <= ?', to)   if to.present?
    s
  end

  private

  def default_hourly_rate_from_user
    self.hourly_rate ||= user&.wage_per_hour
  end

  def compute_total_cost
    rate = (hourly_rate || 0).to_d
    hours = (hours_worked || 0).to_d
    self.total_cost = rate * hours
  end
end
