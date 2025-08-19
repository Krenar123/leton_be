class RenameDueDateForObjectives < ActiveRecord::Migration[8.0]
  def change
    rename_column :objectives, :due_date, :end_date
  end
end
