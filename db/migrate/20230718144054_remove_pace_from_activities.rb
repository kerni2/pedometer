class RemovePaceFromActivities < ActiveRecord::Migration[7.0]
  def change
    remove_column :activities, :pace, :integer
  end
end
