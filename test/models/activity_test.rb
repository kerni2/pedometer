require "test_helper"

class ActivityTest < ActiveSupport::TestCase
  def setup
    @user = users(:confirmed_user)
    @activity = @user.activities.build(date: Time.zone.now, duration: 10, distance: 0, unit: :kilometers)
  end

  test "should be valid" do
    assert @activity.valid?
  end

  test "should have date" do
    @activity.date = nil
    assert_not @activity.valid?
  end

  test "duration should be positive" do
    @activity.duration = -1
    assert_not @activity.valid?

    @activity.duration = 0
    assert_not @activity.valid?    
  end

  test "distance should be positive" do
    @activity.distance = -1
    assert_not @activity.valid?
  end 

  test "should have duration" do
    @activity.duration = nil
    assert_not @activity.valid?
  end

  test "should have distance" do
    @activity.distance = nil
    assert_not @activity.valid?
  end 

  test "should have unit if distance is set" do
    @activity.distance = 1
    @activity.unit = nil
    assert_not @activity.valid?
  end
end
