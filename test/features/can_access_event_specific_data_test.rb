require './test/test_helper'

class CanAccessEventSpecificData < FeatureTest
  def test_it_can_see_total_received_for_event
    click_link "Events"
    click_link "socialLogin"
    assert page.has_content?("Total Received:")
  end
end
