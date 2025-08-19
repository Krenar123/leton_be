class CreateReports < ActiveRecord::Migration[8.0]
  def change
    create_table :reports do |t|
      t.string :ref, null: false, index: { unique: true }
      t.string :name
      t.integer :report_type, default: 0 # enum: financial, project_status, team_performance, client_summary
      t.text :project_ids, array: true, default: []
      t.date :date_range_start
      t.date :date_range_end
      t.jsonb :parameters
      t.string :file_path
      t.references :generated_by, foreign_key: { to_table: :users }
      t.timestamps
    end    
  end
end
