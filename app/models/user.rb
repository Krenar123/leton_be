class User < ApplicationRecord
  has_secure_password

  belongs_to :organization, optional: false

  has_many :clients, foreign_key: :created_by_id
  has_many :suppliers, foreign_key: :created_by_id
  has_many :projects, foreign_key: :created_by_id
  has_many :objectives, foreign_key: :created_by_id
  has_many :tasks, foreign_key: :created_by_id
  has_many :item_lines, foreign_key: :created_by_id
  has_many :invoices, foreign_key: :created_by_id
  has_many :payments, foreign_key: :created_by_id
  has_many :team_costs
  has_many :notes, foreign_key: :created_by_id
  has_many :documents, foreign_key: :uploaded_by_id
  has_many :folders, foreign_key: :created_by_id
  has_many :calendar_events, foreign_key: :created_by_id
  has_many :organized_meetings, class_name: "Meeting", foreign_key: :organizer_id

  enum :role, { admin: 0, manager: 1, employee: 2 }

  

  validates :email, presence: true, uniqueness: { scope: :organization_id }
end
