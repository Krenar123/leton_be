class AddMemberFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :position, :string
    add_column :users, :department, :string
    add_column :users, :phone, :string
    add_column :users, :address, :text
    add_column :users, :wage_per_hour, :decimal, precision: 8, scale: 2
  end
end
