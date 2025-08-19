class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :ref, null: false, index: { unique: true }
      t.string :email, null: false, index: { unique: true }
      t.string :password_digest, null: false
      t.string :full_name
      t.string :avatar_url
      t.integer :role, default: 0 # enum: admin, manager, employee
      t.timestamps
    end    
  end
end
