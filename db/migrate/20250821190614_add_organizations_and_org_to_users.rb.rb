# db/migrate/20250818_add_organizations_and_org_to_users.rb
class AddOrganizationsAndOrgToUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :organizations do |t|
      t.string :ref, null: false
      t.string :name, null: false
      t.timestamps
      t.index :ref, unique: true
      t.index :name, unique: true
    end

    change_table :users do |t|
      t.references :organization, foreign_key: true
      # Optional: remove global unique index on email if you want same email in multiple orgs
      # remove_index :users, :email
      # add_index :users, [:email, :organization_id], unique: true
    end
  end
end
