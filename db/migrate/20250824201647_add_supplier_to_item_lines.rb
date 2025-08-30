class AddSupplierToItemLines < ActiveRecord::Migration[8.0]
  def change
    add_reference :item_lines, :supplier, foreign_key: true, index: true, null: true
  end
end
