class BillLine < ApplicationRecord
  belongs_to :bill
  belongs_to :item_line

  validates :amount, numericality: { greater_than_or_equal_to: 0 }
end