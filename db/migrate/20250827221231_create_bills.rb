class CreateBills < ActiveRecord::Migration[8.0]
  def change
    create_table :bills do |t|
      t.string  :ref, null: false
      t.bigint  :project_id,  null: false
      t.bigint  :supplier_id, null: false
      t.bigint  :item_line_id
      t.string  :bill_number, null: false
      t.decimal :amount
      t.decimal :tax_amount
      t.decimal :total_amount
      t.date    :issue_date
      t.date    :due_date
      t.integer :status, default: 0
      t.date    :payment_date
      t.bigint  :created_by_id

      t.timestamps
    end

    add_index :bills, :ref, unique: true
    add_index :bills, :project_id
    add_index :bills, :supplier_id
    add_index :bills, :item_line_id
    add_index :bills, :bill_number, unique: true

    add_foreign_key :bills, :projects
    add_foreign_key :bills, :suppliers
    add_foreign_key :bills, :item_lines
    add_foreign_key :bills, :users, column: :created_by_id
  end
end
