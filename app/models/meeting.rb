class Meeting < ApplicationRecord
  belongs_to :project
  belongs_to :organizer, class_name: 'User'

  has_many :meeting_participants
  has_many :calendar_events

  enum :meeting_type, { internal: 0, client: 1, supplier: 2, review: 3 }
  enum :status, { scheduled: 0, completed: 1, cancelled: 2 }

  

  validates :title, :meeting_date, presence: true
end
