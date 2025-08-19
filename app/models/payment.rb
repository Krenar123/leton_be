class Payment < ApplicationRecord
  belongs_to :invoice
  belongs_to :created_by, class_name: 'User'

  validates :amount, :payment_date, presence: true

  
end
