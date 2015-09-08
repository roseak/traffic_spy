require "./test/test_helper"

class NoEventHasBeenDefined < FeatureTest
  def test_reaches_error_page_if_no_event_has_been_defined
    visit "/sources/r3m/events/johnnyutah"

    assert page.has_content?("Error")
    assert page.has_content?("No event with that name has been defined.")
  end
end
