class Bill < ApplicationRecord
  belongs_to :project
  belongs_to :supplier
  belongs_to :created_by, class_name: 'User', optional: true
  #belongs_to :item_line, optional: true
  has_many :bill_lines, dependent: :destroy
  has_many :item_lines, through: :bill_lines

  has_many :payments, as: :payable, dependent: :destroy

  enum :status, { draft: 0, issued: 1, partially_paid: 2, paid: 3, void: 4 }

  def paid_total
    payments.sum(:amount).to_d
  end

  def lines_total
    bill_lines.sum(:amount)
  end

  def outstanding
    (total_amount.presence || amount.presence || lines_total || 0).to_d - paid_total
  end
end
