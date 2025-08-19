class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.string :ref, null: false, index: { unique: true }
      t.references :objective, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.integer :status, default: 0, null: false # enum: not_started, in_progress, completed, on_hold
      t.integer :priority, default: 1, null: false # enum: low, medium, high, critical
      t.date :start_date
      t.date :due_date
      t.references :assigned_to, foreign_key: { to_table: :users }
      t.decimal :estimated_hours, precision: 5, scale: 2
      t.decimal :actual_hours, precision: 5, scale: 2
      t.references :created_by, foreign_key: { to_table: :users }
      t.timestamps
    end    
  end
end
