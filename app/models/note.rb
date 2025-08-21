class Note < ApplicationRecord
  belongs_to :project, optional: true
  belongs_to :client, optional: true
  belongs_to :supplier, optional: true
  belongs_to :user, optional: true
  belongs_to :created_by, class_name: 'User'

  enum :note_type, {
    general: 0,
    meeting: 1,
    requirements: 2,
    financial: 3,
    other: 4
  }

  validates :title, :content, presence: true
end
