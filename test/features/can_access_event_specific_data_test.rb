require "./test/test_helper"

class CanAccessEventSpecificData < FeatureTest
  def test_it_can_see_total_received_for_event
    click_link "Events"
    click_link "partyTime"

    assert_equal "/sources/r3m/events/partyTime", current_path
    assert page.has_content?("3")
  end
end
