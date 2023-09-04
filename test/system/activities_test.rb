require "application_system_test_case"

class ActivitiesTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:confirmed_user_with_activities)
    @user_with_shoe = users(:confirmed_user_with_shoe)
    @shoe = shoes(:confirmed_user_with_shoes_shoe)
    @activity = @user.activities.last
  end

  test "should create activity and calculate page" do
    sign_in @user

    visit new_activity_path
    fill_in "Distance", with: "10.0"
    select "Miles"
    fill_in "Hours", with: "1"
    fill_in "Minutes", with: "10"
    fill_in "Seconds", with: "0"

    click_button "Create Activity"

    assert_selector "p", text: "00:07:00"
  end

  test "should update activity" do
    sign_in @user

    visit edit_activity_path(@activity)
    fill_in "Distance", with: "320.11"
    select "Meters"

    click_button "Update Activity"

    assert_selector "p", text: "Edited Activity"
  end

  test "should delete activity" do
    sign_in @user

    visit edit_activity_path(@activity)

    accept_alert do
      click_button "Destroy"
    end

    assert_selector "p", text: "Activity Deleted"
  end

  test "should render error" do
    sign_in @user

    visit new_activity_path
    click_button "Create Activity"

    assert_selector "#form-error"
  end

  test "should paginate activities" do
    sign_in @user

    visit activities_path
    click_link "Next"
    click_link "Prev"
  end

  test "should set shoe when creating an activity" do
    sign_in @user_with_shoe

    visit new_activity_path

    fill_in "Distance", with: "10.0"
    select "Miles"
    select "#{@shoe.name_with_miles}"

    click_button "Create Activity"

    assert_text "Created Activity"
  end  
end
