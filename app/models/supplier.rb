class Supplier < ApplicationRecord
  belongs_to :created_by, class_name: 'User'

  has_many :item_lines, dependent: :nullify
  has_many :bills, dependent: :nullify
  has_many :projects_via_items, -> { distinct }, through: :item_lines, source: :project
  has_many :projects_via_bills, -> { distinct }, through: :bills, source: :project 
  has_many :documents

  enum :status, { active: 0, inactive: 1 }

  validates :company, presence: true
end
