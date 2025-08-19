class CreateDocuments < ActiveRecord::Migration[8.0]
  def change
    create_table :documents do |t|
      t.string :ref, null: false, index: { unique: true }
      t.references :project, foreign_key: true
      t.references :client, foreign_key: true
      t.references :supplier, foreign_key: true
      t.references :folder, foreign_key: true
      t.string :name
      t.string :file_path
      t.bigint :file_size
      t.string :file_type
      t.references :uploaded_by, foreign_key: { to_table: :users }
      t.timestamps
    end    
  end
end
