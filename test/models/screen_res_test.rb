require './test/test_helper'

class ScreenResTest < Minitest::Test
  include Rack::Test::Methods 

  def app
    TrafficSpy::Server
  end

  def setup
    DatabaseCleaner.start

    attributes = {'identifier' => 'r3m', 'rootUrl' => 'http://r3m.com'}
    post('/sources', attributes)

    attributes2 = {'identifier' => '123', 'rootUrl' => 'http://123.com'}
    post('/sources', attributes2)

    payload1 = '{
      "url":"http://r3m.com/blog",
      "requestedAt":"2013-02-16 21:38:22 -0700",
      "respondedIn":37,
      "referredBy":"http://r3m.com",
      "requestType":"GET",
      "parameters":[],
      "eventName": "socialLogin",
      "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
      "resolutionWidth":"800",
      "resolutionHeight":"600",
      "ip":"63.29.38.211"
    }'

    payload2 = '{
      "url":"http://r3m.com/blog",
      "requestedAt":"2013-01-16 21:38:23 -0700",
      "respondedIn":37,
      "referredBy":"http://r3m.com",
      "requestType":"GET",
      "parameters":[],
      "eventName": "socialLogin",
      "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
      "resolutionWidth":"1920",
      "resolutionHeight":"1280",
      "ip":"63.29.38.212"
    }'

    payload3 = '{
      "url":"http://r3m.com/blog",
      "requestedAt":"2013-04-16 21:38:24 -0700",
      "respondedIn":37,
      "referredBy":"http://r3m.com",
      "requestType":"DELETE",
      "parameters":[],
      "eventName": "socialLogin",
      "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
      "resolutionWidth":"1920",
      "resolutionHeight":"1280",
      "ip":"63.29.38.213"
    }'

    payload4 = '{
      "url":"http://r3m.com/pizza",
      "requestedAt":"2013-02-16 21:38:25 -0700",
      "respondedIn":37,
      "referredBy":"http://r3m.com",
      "requestType":"PUSH",
      "parameters":[],
      "eventName": "socialLogin",
      "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
      "resolutionWidth":"1920",
      "resolutionHeight":"1280",
      "ip":"63.29.38.214"
    }'

    payload5 = '{
      "url":"http://r3m.com/jonothy",
      "requestedAt":"2013-02-16 21:38:26 -0700",
      "respondedIn":37,
      "referredBy":"http://r3m.com",
      "requestType":"GET",
      "parameters":[],
      "eventName": "socialLogin",
      "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
      "resolutionWidth":"2500",
      "resolutionHeight":"1800",
      "ip":"63.29.38.215"
    }'

    payload6 = '{
      "url":"http://r3m.com/pizza",
      "requestedAt":"2013-07-16 21:38:27 -0700",
      "respondedIn":37,
      "referredBy":"http://r3m.com",
      "requestType":"POST",
      "parameters":[],
      "eventName": "socialLogin",
      "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
      "resolutionWidth":"1920",
      "resolutionHeight":"1280",
      "ip":"63.29.38.216"
    }'

    post('/sources/r3m/data', {'payload' => payload2})
    post('/sources/r3m/data', {'payload' => payload5})
    post('/sources/r3m/data', {'payload' => payload3})
    post('/sources/r3m/data', {'payload' => payload1})
    post('/sources/r3m/data', {'payload' => payload4})
    post('/sources/r3m/data', {'payload' => payload6})
  end

  def test_it_does_not_store_duplicate_screen_resolutions
    actual_resolutions = TrafficSpy::Resolution.all.sort
    
    actual = actual_resolutions.map { |o| o.resolution }
    expected = ["1920x1280", "2500x1800", "800x600"].sort

    assert_equal expected, actual
  end

  def teardown
    DatabaseCleaner.clean
  end
end
