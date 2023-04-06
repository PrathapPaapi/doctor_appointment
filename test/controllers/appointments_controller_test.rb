require "test_helper"

class AppointmentsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get appointments_index_url
    assert_response :success
  end

  test "should get add_details" do
    get appointments_add_details_url
    assert_response :success
  end

  test "should get congrats" do
    get appointments_congrats_url
    assert_response :success
  end

  test "should get select_slot" do
    get appointments_select_slot_url
    assert_response :success
  end
end
