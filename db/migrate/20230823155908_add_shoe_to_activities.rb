class AddShoeToActivities < ActiveRecord::Migration[7.0]
  def change
    add_reference :activities, :shoe, foreign_key: true
  end
end
