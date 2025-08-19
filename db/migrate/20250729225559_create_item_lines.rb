class CreateItemLines < ActiveRecord::Migration[8.0]
  def change
    create_table :item_lines do |t|
      t.string :ref, null: false, index: { unique: true }
      t.references :project, null: false, foreign_key: true
      t.references :parent, foreign_key: { to_table: :item_lines }
      t.string :item_line
      t.integer :level
      t.string :contractor
      t.string :unit
      t.decimal :quantity
      t.decimal :unit_price
      t.decimal :estimated_cost
      t.decimal :actual_cost
      t.decimal :estimated_revenue
      t.decimal :actual_revenue
      t.date :start_date
      t.date :due_date
      t.integer :status, default: 0 # enum: not_started, in_progress, completed, on_hold
      t.references :depends_on, foreign_key: { to_table: :item_lines }
      t.references :created_by, foreign_key: { to_table: :users }
      t.timestamps
    end    
  end
end
