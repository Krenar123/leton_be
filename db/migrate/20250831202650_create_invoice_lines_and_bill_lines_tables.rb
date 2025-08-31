class CreateInvoiceLinesAndBillLinesTables < ActiveRecord::Migration[8.0]
  def change
    create_table :invoice_lines do |t|
      t.references :invoice, null: false, foreign_key: true
      t.references :item_line, null: false, foreign_key: true
      t.decimal :amount, null: false, default: 0
      t.timestamps
    end
    
    create_table :bill_lines do |t|
      t.references :bill, null: false, foreign_key: true
      t.references :item_line, null: false, foreign_key: true
      t.decimal :amount, null: false, default: 0
      t.timestamps
    end
  end
end
