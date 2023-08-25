class AddUserToShoes < ActiveRecord::Migration[7.0]
  def change
    add_reference :shoes, :user, null: false, foreign_key: true
  end
end
