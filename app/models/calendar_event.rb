class CalendarEvent < ApplicationRecord
  belongs_to :project, optional: true
  belongs_to :meeting, optional: true
  belongs_to :created_by, class_name: 'User'

  enum :event_type, { meeting: 0, deadline: 1, milestone: 2, personal: 3 }

  validates :title, :start_date, presence: true
end
