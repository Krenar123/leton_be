class CreateMeetingParticipants < ActiveRecord::Migration[8.0]
  def change
    create_table :meeting_participants do |t|
      t.references :meeting, null: false, foreign_key: true
      t.references :user, foreign_key: true
      t.references :client, foreign_key: true
      t.references :supplier, foreign_key: true
      t.integer :response, default: 0 # enum: pending, accepted, declined
    end    
  end
end
