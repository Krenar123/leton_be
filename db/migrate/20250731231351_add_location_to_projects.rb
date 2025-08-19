class AddLocationToProjects < ActiveRecord::Migration[8.0]
  def change
    add_column :projects, :location, :string
  end
end
