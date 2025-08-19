class CreateObjectives < ActiveRecord::Migration[8.0]
  def change
    create_table :objectives do |t|
      t.string :ref, null: false, index: { unique: true }
      t.references :project, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.integer :status, default: 0, null: false # enum: not_started, in_progress, completed, on_hold
      t.integer :priority, default: 1, null: false # enum: low, medium, high, critical
      t.date :start_date
      t.date :due_date
      t.references :assigned_to, foreign_key: { to_table: :users }
      t.references :depends_on, foreign_key: { to_table: :objectives }
      t.references :created_by, foreign_key: { to_table: :users }
      t.timestamps
    end    
  end
end
