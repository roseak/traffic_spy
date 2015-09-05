require './test/test_helper'

class OperatingSystemTest < Minitest::Test
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
      "userAgent":"Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36",
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
      "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.124 Safari/537.36",
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
      "userAgent":"Mozilla/5.0 (Windows NT 6.1) Chrome/24.0.1309.0 Safari/537.17",
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

  def test_it_does_not_store_duplicate_operating_systems
    actual_operating_systems = TrafficSpy::OperatingSystem.all.sort

    actual = actual_operating_systems.map { |o| o.operating_system }
    expected = ["Windows 7", "OS X 10.8.2", "OS X 10.10.1"]

    assert_equal expected, actual
  end

  def test_it_ranks_visits_for_operating_systems
    identifier = 'r3m'
    expected_order = ["OS X 10.8.2", "Windows 7", "OS X 10.10.1"]
    expected_visits = [3, 2, 1]
    expected = expected_order.zip(expected_visits).to_h

    actual = TrafficSpy::OperatingSystem.ranked_operating_systems_with_count(identifier)

    assert_equal expected, actual
  end

  def teardown
    DatabaseCleaner.clean
  end
end
