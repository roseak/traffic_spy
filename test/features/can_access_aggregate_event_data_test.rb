require './test/test_helper'

class CanAccessEventData < FeatureTest
  def test_can_see_link_to_event_data_on_stats_page
    assert_equal "/sources/r3m", current_path
    click_link "Events"
    assert_equal "/sources/r3m/events", current_path
  end
end
