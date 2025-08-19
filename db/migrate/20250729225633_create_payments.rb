class CreatePayments < ActiveRecord::Migration[8.0]
  def change
    create_table :payments do |t|
      t.string :ref, null: false, index: { unique: true }
      t.references :invoice, null: false, foreign_key: true
      t.decimal :amount
      t.string :payment_method
      t.date :payment_date
      t.string :reference_number
      t.text :notes
      t.references :created_by, foreign_key: { to_table: :users }
      t.timestamps
    end    
  end
end
