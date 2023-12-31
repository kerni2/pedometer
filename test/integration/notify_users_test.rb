require "test_helper"

class NotifyUsersTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:confirmed_user_with_shoe)
    @shoe = shoes(:confirmed_user_with_shoes_shoe)    
  end

  test "should notifiy user when allowed_distance_in_miles is reached" do
    difference = @shoe.allowed_distance_in_miles - @shoe.distance_in_miles
    sign_in @user
    assert_emails 1 do
      post activities_path, params: { activity: { date: Time.zone.now, distance: difference, unit: "miles", user: @user, shoe_id: @shoe_id } }
    end
  end
end
