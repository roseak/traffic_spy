require './test/test_helper'
module TrafficSpy
class DisplaysMostToLeastRequestedEventsTest < FeatureTest
  include Rack::Test::Methods
  attr_reader :payload1, :payload2, :payload3, :payload4, :payload5, :payload6,
              :attributes1, :attributes2

  def app
    TrafficSpy::Server
  end

  def app
    TrafficSpy::Server
  end

  def test_can_get_list_of_urls_from_most_to_least_requested
    skip
    click_link("Events")

    assert_equal "/sources/r3m/events", current_path

    assert page.has_content?("Faz")
    assert page.has_content?("boo")
    assert page.has_content?("socialLogin")
    assert page.has_content?("3")
    assert page.has_content?("2")
    assert page.has_content?("1")
  end

  def teardown
    DatabaseCleaner.clean
  end
end
end
