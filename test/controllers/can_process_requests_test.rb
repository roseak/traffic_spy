require './test/test_helper'
require './app/models/client'
require './app/controllers/payload'

class RegisterTest < Minitest::Test
  include Rack::Test::Methods

  def app
    TrafficSpy::Server
  end

  def test_gets_200_from_good_request
    attributes = {:identifier => 'r3m', :root_url => 'http://r3m.com'}
    post('/sources', attributes)

    payload = '{
      "url":"http://r3m.com/blog",
      "requestedAt":"2013-02-16 21:38:28 -0700",
      "respondedIn":37,
      "referredBy":"http://r3m.com",
      "requestType":"GET",
      "parameters":[],
      "eventName": "socialLogin",
      "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
      "resolutionWidth":"1920",
      "resolutionHeight":"1280",
      "ip":"63.29.38.211"
    }'

    hash = JSON.parse(payload)

    post('/sources/r3m/data', hash)

    assert_equal 200, last_response.status
    # binding.pry
    url = TrafficSpy::Url.find(1)
    assert_equal TrafficSpy::Client.find(1), TrafficSpy::Client.find(url.client_id)

  end

  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end

end
