class Organization < ApplicationRecord
  has_many :users, dependent: :restrict_with_exception
  validates :name, presence: true
  before_create { self.ref ||= SecureRandom.hex(16) }
end