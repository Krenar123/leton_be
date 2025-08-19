class Objective < ApplicationRecord
  belongs_to :project
  belongs_to :assigned_to, class_name: 'User', optional: true
  belongs_to :depends_on, class_name: 'Objective', optional: true
  belongs_to :created_by, class_name: 'User'

  has_many :tasks

  #enum :status, { not_started: 0, in_progress: 1, completed: 2, on_hold: 3 }
  enum :status, { pending: 0, in_progress: 1, completed: 2, on_hold: 3 }
  enum :priority, { low: 0, medium: 1, high: 2, critical: 3 }

  

  validates :title, presence: true
end
