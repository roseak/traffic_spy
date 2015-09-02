require './test/test_helper'

class RegisterTest < Minitest::Test
  include Rack::Test::Methods

  def app
    TrafficSpy::Server
  end

  def test_can_register_with_good_params
    attributes = {:identifier => 'jumpstartlab', :root_url=>'http://jumpstartlab.com'}
    post('/sources', attributes)

    assert_equal 200, last_response.status
    assert_equal '{"identifier":"jumpstartlab"}', last_response.body
  end

  def test_can_register_with_other_params
    attributes = {:identifier => 'jumpstartfab', :root_url=>'http://jumpstartfab.com'}
    post('/sources', attributes)

    assert_equal 200, last_response.status
    assert_equal '{"identifier":"jumpstartfab"}', last_response.body
  end

  def test_gets_400_from_bad_input_params
    attributes = {:identifier => 'jumpstartlab'}
    post('/sources', attributes)

    assert_equal 400, last_response.status
  end

end
