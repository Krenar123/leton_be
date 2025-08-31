class InvoiceLine < ApplicationRecord
  belongs_to :invoice
  belongs_to :item_line
  
  validates :amount, numericality: { greater_than_or_equal_to: 0 }
end