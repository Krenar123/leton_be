class CreateNotes < ActiveRecord::Migration[8.0]
  def change
    create_table :notes do |t|
      t.string :ref, null: false, index: { unique: true }
      t.references :project, foreign_key: true
      t.references :client, foreign_key: true
      t.references :supplier, foreign_key: true
      t.references :user, foreign_key: true
      t.string :title
      t.text :content
      t.integer :note_type, default: 0 # enum: general, meeting, follow_up, issue
      t.references :created_by, foreign_key: { to_table: :users }
      t.timestamps
    end    
  end
end
