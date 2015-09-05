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

  def test_can_get_to_operating_system_page
    visit('/sources/derp')
    click_link('Operating Systems')
    assert_equal '/sources/derp/os', current_path
  end
end
