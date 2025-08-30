class AddItemLineToInvoices < ActiveRecord::Migration[8.0]
  def change
    add_column :invoices, :item_line_id, :bigint
    add_index  :invoices, :item_line_id
    add_foreign_key :invoices, :item_lines
  end
end
