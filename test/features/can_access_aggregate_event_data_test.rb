require "./test/test_helper"

class CanAccessEventData < FeatureTest
  def test_can_access_aggregate_event_data
    assert_equal "/sources/r3m", current_path
    click_link "Events"
    assert_equal "/sources/r3m/events", current_path

    assert page.has_content?("Most Received Event: partyTime")
    within(:css, ".list-group") do
      assert page.has_content?("partyTime")
      assert page.has_content?("parade")
      assert page.has_content?("socialLogin")
    end
  end
end
