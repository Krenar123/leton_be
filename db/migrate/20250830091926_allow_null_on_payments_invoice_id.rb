class AllowNullOnPaymentsInvoiceId < ActiveRecord::Migration[8.0]
  def up
    change_column_null :payments, :invoice_id, true
  end

  def down
    # Will fail if any NULLs exist, so only use if you really need to revert.
    change_column_null :payments, :invoice_id, false
  end
end
