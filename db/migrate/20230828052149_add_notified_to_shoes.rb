class AddNotifiedToShoes < ActiveRecord::Migration[7.0]
  def change
    add_column :shoes, :notified, :boolean, default: false
  end
end
