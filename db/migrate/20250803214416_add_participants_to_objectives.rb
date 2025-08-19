class AddParticipantsToObjectives < ActiveRecord::Migration[8.0]
  def change
    add_column :objectives, :participants, :text, array: true, default: []
  end
end
