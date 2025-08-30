class Payment < ApplicationRecord
  belongs_to :payable, polymorphic: true
  belongs_to :created_by, class_name: 'User', optional: true

  validates :amount, numericality: { greater_than: 0 }
  validates :payment_date, presence: true
end
