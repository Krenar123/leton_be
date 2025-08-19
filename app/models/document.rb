class Document < ApplicationRecord
  belongs_to :project
  belongs_to :client, optional: true
  belongs_to :supplier, optional: true
  belongs_to :folder, optional: true
  belongs_to :uploaded_by, class_name: 'User'

  

  validates :name, :file_path, presence: true
end
