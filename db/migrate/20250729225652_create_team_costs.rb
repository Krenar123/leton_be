class CreateTeamCosts < ActiveRecord::Migration[8.0]
  def change
    create_table :team_costs do |t|
      t.string :ref, null: false, index: { unique: true }
      t.references :project, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.decimal :hours_worked
      t.decimal :hourly_rate
      t.decimal :total_cost
      t.date :work_date
      t.text :description
      t.references :created_by, foreign_key: { to_table: :users }
      t.timestamps
    end    
  end
end
