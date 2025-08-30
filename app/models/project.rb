class Project < ApplicationRecord
  belongs_to :client
  belongs_to :project_manager, class_name: 'User', optional: true
  belongs_to :created_by, class_name: 'User'

  has_many :objectives
  has_many :item_lines
  has_many :invoices
  has_many :meetings
  has_many :notes
  has_many :documents
  has_many :folders
  has_many :calendar_events
  has_many :bills
  has_many :team_costs

  enum :status, { planning: 0, active: 1, on_hold: 2, completed: 3, cancelled: 4 }

  validates :name, presence: true
end
