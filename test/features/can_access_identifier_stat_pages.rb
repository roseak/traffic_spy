require './test/test_helper'

class CanAccessIdentifierStatPages < FeatureTest
  include Rack::Test::Methods

  def app
    TrafficSpy::Server
  end

  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end

  def test_the_page_has_stuff
    visit('/sources/hello')

    assert page.has_content?("Statistics")
    within(:css, ".list-group") {
      assert page.has_content?("URLs")
      assert page.has_content?("Browsers")
      assert page.has_content?("Operating Systems")
      assert page.has_content?("Screen Resolutions")
      assert page.has_content?("Average Response Time")
      assert page.has_content?("Events")
    }
  end
end
