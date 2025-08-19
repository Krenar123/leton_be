class MeetingParticipant < ApplicationRecord
  belongs_to :meeting
  belongs_to :user
  belongs_to :client, optional: true
  belongs_to :supplier, optional: true

  enum :response, { pending: 0, accepted: 1, declined: 2 }

  
end
