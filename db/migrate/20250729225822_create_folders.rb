class CreateFolders < ActiveRecord::Migration[8.0]
  def change
    create_table :folders do |t|
      t.string :ref, null: false, index: { unique: true }
      t.references :project, foreign_key: true
      t.references :parent, foreign_key: { to_table: :folders }
      t.string :name
      t.references :created_by, foreign_key: { to_table: :users }
      t.timestamps
    end    
  end
end
