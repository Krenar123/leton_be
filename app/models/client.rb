class Client < ApplicationRecord
  belongs_to :created_by, class_name: 'User'

  has_many :projects
  has_many :notes
  has_many :documents
  has_many :invoices

  has_many :meeting_participants, dependent: :destroy
  has_many :meetings_as_participant, through: :meeting_participants, source: :meeting
  
  # If your Project model has `has_many :meetings`
  has_many :meetings_via_projects, through: :projects, source: :meetings

  # Convenience unified association (distinct to avoid duplicates)
  def meetings
    Meeting
      .left_outer_joins(:project)
      .joins(<<-SQL.squish)
        LEFT JOIN meeting_participants mp
          ON mp.meeting_id = meetings.id
      SQL
      .where("projects.client_id = :cid OR mp.client_id = :cid", cid: id)
      .distinct
  end

  enum :status, { active: 0, inactive: 1, prospect: 2 }

  validates :company, :contact_name, presence: true
end
