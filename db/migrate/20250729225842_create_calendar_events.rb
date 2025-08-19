class CreateCalendarEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :calendar_events do |t|
      t.string :ref, null: false, index: { unique: true }
      t.string :title
      t.text :description
      t.datetime :start_date
      t.datetime :end_date
      t.boolean :all_day, default: false
      t.integer :event_type, default: 0 # enum: meeting, deadline, milestone, personal
      t.string :color
      t.references :project, foreign_key: true
      t.references :meeting, foreign_key: true
      t.references :created_by, foreign_key: { to_table: :users }
      t.timestamps
    end    
  end
end
