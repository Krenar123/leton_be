class CreateSuppliers < ActiveRecord::Migration[8.0]
  def change
    create_table :suppliers do |t|
      t.string :ref, null: false, index: { unique: true }
      t.string :company
      t.string :contact_name
      t.string :email
      t.string :phone
      t.text :address
      t.string :website
      t.string :category
      t.integer :status, default: 0, null: false # enum: active, inactive
      t.references :created_by, null: false, foreign_key: { to_table: :users }
      t.timestamps
    end    
  end
end
