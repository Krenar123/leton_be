class CreateClients < ActiveRecord::Migration[8.0]
  def change
    create_table :clients do |t|
      t.string :ref, null: false, index: { unique: true }
      t.string :company
      t.string :contact_name
      t.string :email
      t.string :phone
      t.text :address
      t.string :website
      t.string :industry
      t.integer :status, default: 0, null: false # enum: active, inactive, prospect
      t.references :created_by, null: false, foreign_key: { to_table: :users }
      t.timestamps
    end    
  end
end
