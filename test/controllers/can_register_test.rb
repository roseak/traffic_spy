require './test/test_helper'

class RegisterTest < Minitest::Test
  include Rack::Test::Methods

  def app
    TrafficSpy::Server
  end

  def test_can_register_with_good_params
    attributes = {'identifier' => 'jumpstartlab', 'rootUrl' => 'http://jumpstartlab.com'}
    post('/sources', attributes)

    assert_equal 200, last_response.status
    assert_equal '{"identifier":"jumpstartlab"}', last_response.body
  end

  def test_can_register_with_other_params
    skip
    attributes = {:identifier => 'jumpstartfab', :root_url=>'http://jumpstartfab.com'}
    post('/sources', attributes)

    assert_equal 200, last_response.status
    assert_equal '{"identifier":"jumpstartfab"}', last_response.body
  end

  def test_gets_400_from_bad_input_params
    skip
    attributes = {:identifier => 'jumpstartlab'}
    post('/sources', attributes)

    assert_equal 400, last_response.status
    assert_equal "Root url can't be blank", last_response.body
    #should give different error messages for different missing params
  end

  def test_gets_403_when_identifier_already_exists
    skip
    attributes = {:identifier => 'jumpstartlab', :root_url=>'http://jumpstartlab.com'}
    post('/sources', attributes)
    post('/sources', attributes)

    assert_equal 403, last_response.status
    assert_equal "Identifier has already been taken", last_response.body
  end

  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end

end
