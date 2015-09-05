require './test/test_helper'

class CanAccessEventData < FeatureTest
<<<<<<< HEAD
  def test_can_see_link_to_event_data_on_stats_page
    assert_equal "/sources/r3m", current_path
    click_link "Events"
    assert_equal "/sources/r3m/events", current_path
=======
  def test_can_access_aggregate_event_data
    assert_equal "/sources/r3m", current_path
    click_link "Events"
    assert_equal "/sources/r3m/events", current_path

    assert page.has_content?("partyTime")
    assert page.has_content?("parade")
    assert page.has_content?("socialLogin")
>>>>>>> WIP can sort events by popularity
  end
end
