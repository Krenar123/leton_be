class Backstop < ApplicationRecord
  belongs_to :project
  belongs_to :assigned_to, class_name: 'User', optional: true
  belongs_to :created_by, class_name: 'User'

  enum :status, { pending: 0, resolved: 1, overdue: 2 }
  enum :priority, { low: 0, medium: 1, high: 2, critical: 3 }

  validates :title, :due_date, presence: true
end
