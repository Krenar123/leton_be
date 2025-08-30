# app/models/invoice.rb
class Invoice < ApplicationRecord
  belongs_to :project
  belongs_to :client
  belongs_to :created_by, class_name: 'User', optional: true
  belongs_to :item_line, class_name: 'ItemLine', optional: true

  has_many :payments, as: :payable, dependent: :destroy

  enum :status, { draft: 0, sent: 1, paid: 2, void: 3, partial: 4 }

  validates :invoice_number, presence: true
  validates :amount, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  def paid_total
    payments.sum(:amount)
  end

  def outstanding
    (total_amount || amount || 0) - paid_total
  end
end
