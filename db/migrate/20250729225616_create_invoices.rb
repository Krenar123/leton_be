class CreateInvoices < ActiveRecord::Migration[8.0]
  def change
    create_table :invoices do |t|
      t.string :ref, null: false, index: { unique: true }
      t.references :project, null: false, foreign_key: true
      t.references :client, null: false, foreign_key: true
      t.string :invoice_number, null: false, index: { unique: true }
      t.decimal :amount
      t.decimal :tax_amount
      t.decimal :total_amount
      t.date :issue_date
      t.date :due_date
      t.integer :status, default: 0 # enum: draft, sent, paid, overdue, cancelled
      t.date :payment_date
      t.references :created_by, foreign_key: { to_table: :users }
      t.timestamps
    end    
  end
end
