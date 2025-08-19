class CreateProjects < ActiveRecord::Migration[8.0]
  def change
    create_table :projects do |t|
      t.string :ref, null: false, index: { unique: true }
      t.string :name
      t.text :description
      t.references :client, foreign_key: true
      t.integer :status, default: 0, null: false # enum: planning, active, on_hold, completed, cancelled
      t.date :start_date
      t.date :end_date
      t.decimal :budget, precision: 12, scale: 2
      t.references :project_manager, foreign_key: { to_table: :users }
      t.references :created_by, foreign_key: { to_table: :users }
      t.timestamps
    end    
  end
end
