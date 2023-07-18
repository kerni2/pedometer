class AddCalculatedPaceToActivities < ActiveRecord::Migration[7.0]
  def change
    add_column :activities, :calculated_pace, :decimal
  end
end
