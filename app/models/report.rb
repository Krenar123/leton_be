class Report < ApplicationRecord
  belongs_to :generated_by, class_name: 'User'

  enum :report_type, {
    financial: 0,
    project_status: 1,
    team_performance: 2,
    client_summary: 3
  }

  

  validates :name, :report_type, :file_path, presence: true
end
