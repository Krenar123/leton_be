class AddCostCodeToItemLines < ActiveRecord::Migration[8.0]
  def change
    add_column :item_lines, :cost_code, :string
    add_column :item_lines, :parent_cost_code, :string
  end
end
