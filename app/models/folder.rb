class Folder < ApplicationRecord
  belongs_to :project
  belongs_to :parent, class_name: 'Folder', optional: true
  belongs_to :created_by, class_name: 'User'

  has_many :documents

  

  validates :name, presence: true
end
