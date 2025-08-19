class Invoice < ApplicationRecord
  belongs_to :project
  belongs_to :client
  belongs_to :created_by, class_name: 'User'

  has_many :payments

  enum :status, { draft: 0, sent: 1, paid: 2, overdue: 3, cancelled: 4 }

  

  validates :invoice_number, :amount, :total_amount, presence: true
end
