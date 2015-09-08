require './test/test_helper'

class NavigateToRootTest < Minitest::Test
  include Rack::Test::Methods #gives us http verbs to interact with controler

  def app
    TrafficSpy::Server
  end

  def test_it_receives_instructions_when_navigating_to_root
    get "/"

    assert last_response.body =~ /This is not a valid URL/
    assert last_response.body =~ /Please enter a path like this:/
  end

  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end

end