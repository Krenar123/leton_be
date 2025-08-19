class CreateMeetings < ActiveRecord::Migration[8.0]
  def change
    create_table :meetings do |t|
      t.string :ref, null: false, index: { unique: true }
      t.references :project, foreign_key: true
      t.string :title
      t.text :description
      t.datetime :meeting_date
      t.integer :duration_minutes
      t.string :location
      t.integer :meeting_type, default: 0 # enum: internal, client, supplier, review
      t.references :organizer, foreign_key: { to_table: :users }
      t.integer :status, default: 0 # enum: scheduled, completed, cancelled
      t.timestamps
    end    
  end
end
