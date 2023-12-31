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
    pace = @activity.duration / @activity.distance_in_miles

    assert_equal pace, @activity.reload.calculated_pace
  end
  
  test "should calculate calculated_pace when unit is meters" do
    @activity.distance = 10
    @activity.unit = :meters
    @activity.duration = 3600
    @activity.save
    pace = @activity.duration /  @activity.distance_in_miles

    assert_equal pace, @activity.reload.calculated_pace
  end

  test "should calculate calculated_pace when unit is yards" do
    @activity.distance = 10
    @activity.unit = :yards
    @activity.duration = 3600
    @activity.save
    pace = @activity.duration /  @activity.distance_in_miles

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

  test "should create total record when saved" do
    starting_on = Time.zone.now.beginning_of_week

    7.times do |i|
      @user.activities.create(date: starting_on + i.days, hours: 1, minutes: 0, seconds: 0, unit: "miles", distance: 10)
    end

    @total = @user.totals.last

    assert_equal 25200, @total.duration
    assert_equal 70, @total.distance_in_miles
  end

  test "should update total record when activity is destroyed" do
    @user = users(:confirmed_user)
    @activity_one = @user.activities.create(date: Time.zone.now, hours: 1, minutes: 0, seconds: 0, unit: "miles", distance: 10)
    @activity_two = @user.activities.create(date: Time.zone.now, hours: 1, minutes: 0, seconds: 0, unit: "miles", distance: 10)
    @total = @user.totals.last

    @activity_one.destroy
    assert_equal 3600, @total.reload.duration
    assert_equal 10, @total.reload.distance_in_miles
  end

  test "should update total record when activity is updated" do
    @user = users(:confirmed_user)
    @activity = @user.activities.create(date: Time.zone.now, hours: 1, minutes: 0, seconds: 0, unit: "miles", distance: 10)
    @total = @user.totals.last

    @activity.update(distance: 20, hours: 2, minutes: 0, seconds: 0 )
    assert_equal 7200, @total.reload.duration
    assert_equal 20, @total.reload.distance_in_miles
  end

  test "should update associated shoes distance_in_miles value when activity is created or updated" do
    @user = users(:confirmed_user_with_shoes)
    @shoe = @user.shoes.first
    @activity = @user.activities.create(distance: 10, unit: "miles", shoe: @shoe, date: Time.zone.now)

    assert_equal 10, @shoe.reload.distance_in_miles
  end
end
