class AddHoursMinutesAndSecondsToActivities < ActiveRecord::Migration[7.0]
  def change
    add_column :activities, :hours, :integer
    add_column :activities, :minutes, :integer
    add_column :activities, :seconds, :integer
  end
end
