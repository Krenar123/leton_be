class CreateBackstops < ActiveRecord::Migration[8.0]
  def change
    create_table :backstops do |t|
      t.string :ref, null: false, index: { unique: true }
      t.references :project, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.date :due_date
      t.references :assigned_to, foreign_key: { to_table: :users }
      t.integer :status, default: 0, null: false # enum: pending, resolved, overdue
      t.integer :priority, default: 1, null: false # enum: low, medium, high, critical
      t.references :created_by, foreign_key: { to_table: :users }
      t.timestamps
    end    
  end
end
