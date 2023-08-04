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

  test "should calculate calculated_pace when unit is miles" do
    @activity.distance = 10
    @activity.unit = :miles
    @activity.duration = 3600
    @activity.save

    assert_equal 360, @activity.reload.calculated_pace
  end

  test "should calculate calculated_pace when unit is kilometers" do
    @activity.distance = 10
    @activity.unit = :kilometers
    @activity.duration = 3600
    @activity.save
    pace = @activity.duration / ( @activity.distance * 0.6213712 )

    assert_equal pace, @activity.reload.calculated_pace
  end
  
  test "should calculate calculated_pace when unit is meters" do
    @activity.distance = 10
    @activity.unit = :meters
    @activity.duration = 3600
    @activity.save
    pace = @activity.duration / ( @activity.distance * 0.0006213711985 )

    assert_equal pace, @activity.reload.calculated_pace
  end

  test "should calculate calculated_pace when unit is yards" do
    @activity.distance = 10
    @activity.unit = :yards
    @activity.duration = 3600
    @activity.save
    pace = @activity.duration / ( @activity.distance * 0.0005681818239083977 )

    assert_equal pace, @activity.reload.calculated_pace
  end

  test "should calculate duration" do
    @activity.hours = 1
    @activity.minutes = 30
    @activity.seconds = 15
    @activity.save

    assert_equal 5415, @activity.reload.duration
  end

  test "hours should be a positive integer" do
    @activity.hours = -1
    assert_not @activity.valid?
  end

  test "minutes should be between 0 and 59" do
    @activity.minutes = -1
    assert_not @activity.valid?

    @activity.minutes = 60
    assert_not @activity.valid?   
  end

  test "seconds should be between 0 and 59" do
    @activity.seconds = -1
    assert_not @activity.valid?

    @activity.seconds = 60
    assert_not @activity.valid?   
  end
end
