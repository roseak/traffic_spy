require "./test/test_helper"

class UrlTest < Minitest::Test
  include Rack::Test::Methods

  def app
    TrafficSpy::Server
  end

  def setup
    DatabaseCleaner.start

    attributes = { "identifier" => "r3m", "rootUrl" => "http://r3m.com" }
    post("/sources", attributes)

    attributes2 = { "identifier" => "123", "rootUrl" => "http://123.com" }
    post("/sources", attributes2)

    payload1 = '{
      "url":"http://r3m.com/blog",
      "requestedAt":"2013-02-16 21:38:28 -0700",
      "respondedIn":37,
      "referredBy":"http://www.google.com",
      "requestType":"GET",
      "parameters":[],
      "eventName": "socialLogin",
      "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2227.1 Safari/537.36",
      "resolutionWidth":"1920",
      "resolutionHeight":"1280",
      "ip":"63.29.38.211"
    }'

    payload2 = '{
      "url":"http://r3m.com/blog",
      "requestedAt":"2013-01-16 21:38:28 -0700",
      "respondedIn":25,
      "referredBy":"http://www.google.com",
      "requestType":"GET",
      "parameters":[],
      "eventName": "socialLogin",
      "userAgent":"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2227.0 Safari/537.36",
      "resolutionWidth":"1920",
      "resolutionHeight":"1280",
      "ip":"63.29.38.211"
    }'

    payload3 = '{
      "url":"http://r3m.com/blog",
      "requestedAt":"2013-04-16 21:38:28 -0700",
      "respondedIn":40,
      "referredBy":"http://www.yahoo.com",
      "requestType":"GET",
      "parameters":[],
      "eventName": "socialLogin",
      "userAgent":"Mozilla/5.0 (X11; Linux i586; rv:31.0) Gecko/20100101 Firefox/31.0",
      "resolutionWidth":"1920",
      "resolutionHeight":"1280",
      "ip":"63.29.38.211"
    }'

    payload4 = '{
      "url":"http://r3m.com/pizza",
      "requestedAt":"2013-02-16 21:38:28 -0700",
      "respondedIn":15,
      "referredBy":"",
      "requestType":"GET",
      "parameters":[],
      "eventName": "socialLogin",
      "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
      "resolutionWidth":"1920",
      "resolutionHeight":"1280",
      "ip":"63.29.38.211"
    }'

    payload5 = '{
      "url":"http://r3m.com/jonothy",
      "requestedAt":"2013-02-16 21:38:28 -0700",
      "respondedIn":90,
      "referredBy":"",
      "requestType":"GET",
      "parameters":[],
      "eventName": "socialLogin",
      "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
      "resolutionWidth":"1920",
      "resolutionHeight":"1280",
      "ip":"63.29.38.211"
    }'

    payload6 = '{
      "url":"http://r3m.com/pizza",
      "requestedAt":"2013-07-16 21:38:28 -0700",
      "respondedIn":20,
      "referredBy":"",
      "requestType":"PUSH",
      "parameters":[],
      "eventName": "socialLogin",
      "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
      "resolutionWidth":"1920",
      "resolutionHeight":"1280",
      "ip":"63.29.38.211"
    }'

    payload7 = '{
      "url":"http://123.com/pizza",
      "requestedAt":"2013-07-16 21:38:28 -0700",
      "respondedIn":35,
      "referredBy":"",
      "requestType":"GET",
      "parameters":[],
      "eventName": "socialLogin",
      "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
      "resolutionWidth":"1920",
      "resolutionHeight":"1280",
      "ip":"63.29.38.211"
    }'

    payload8 = '{
      "url":"http://r3m.com/blog",
      "requestedAt":"2013-07-16 21:38:28 -0700",
      "respondedIn":37,
      "referredBy":"http://www.bing.com",
      "requestType":"POST",
      "parameters":[],
      "eventName": "socialLogin",
      "userAgent":"Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; AS; rv:11.0) like Gecko",
      "resolutionWidth":"1920",
      "resolutionHeight":"1280",
      "ip":"63.29.38.211"
    }'

    post("/sources/r3m/data", "payload" => payload2)
    post("/sources/r3m/data", "payload" => payload5)
    post("/sources/r3m/data", "payload" => payload3)
    post("/sources/r3m/data", "payload" => payload1)
    post("/sources/123/data", "payload" => payload7)
    post("/sources/r3m/data", "payload" => payload4)
    post("/sources/r3m/data", "payload" => payload6)
    post("/sources/r3m/data", "payload" => payload8)
  end

  def test_can_find_all_urls_for_identifier
    identifier = "r3m"

    result = TrafficSpy::Url.urls_for_a_client(identifier)
    assert_equal 3, result.length
  end

  def test_it_determines_visits_for_urls
    identifier = "r3m"

    expected_urls = ["http://r3m.com/blog", "http://r3m.com/pizza", "http://r3m.com/jonothy"]
    expected_visits = [4, 2, 1]
    expected = expected_urls.zip(expected_visits).to_h

    actual_as_objects = TrafficSpy::Url.url_visits(identifier)
    actual_for_comparison = actual_as_objects.map do |k, v|
      [k.url, v]
    end.to_h
    actual_for_comparison = actual_for_comparison.sort_by { |_url, visits| -visits }.to_h

    assert_equal expected, actual_for_comparison
  end

  def test_it_ranks_visits_for_urls
    identifier = "r3m"

    expected_order = ["blog", "pizza", "jonothy"]
    expected_visits = [4, 2, 1]
    expected = expected_order.zip(expected_visits).to_h

    actual = TrafficSpy::Url.ranked_url_string_visits(identifier)

    assert_equal expected, actual
  end

  def test_can_format_urls
    tail = TrafficSpy::Url.tail("http://superhappyfuntime.com/super/happy")
    assert_equal "super/happy", tail
  end

  def test_can_get_response_times
    identifier = "r3m"
    path = "blog"
    responded = TrafficSpy::Url.responded_in(identifier, path)
    assert_equal "25", responded["Shortest Response Time"]
    assert_equal "40", responded["Longest Response Time"]
    assert_equal "34", responded["Average Response Time"]
  end

  def test_can_get_refferers
    identifier = "r3m"
    path = "blog"
    actual = TrafficSpy::Url.referrers(identifier, path)
    expected = {
      "http://www.google.com" => 2,
      "http://www.yahoo.com" => 1,
      "http://www.bing.com" => 1,
    }
    assert_equal expected, actual
  end

  def test_can_get_browsers
    identifier = "r3m"
    path = "blog"
    actual = TrafficSpy::Url.browsers(identifier, path)
    expected = {
      "Chrome" => 2,
      "Firefox" => 1,
      "Internet Explorer" => 1,
    }
    assert_equal expected, actual
  end

  def test_can_get_operating_systems
    identifier = "r3m"
    path = "blog"
    actual = TrafficSpy::Url.operating_systems(identifier, path)
    expected = {
      "Windows 7" => 2,
      "Linux i586" => 1,
      "OS X 10.10.1" => 1,
    }
    assert_equal expected, actual
  end

  def test_can_get_ranked_request_types
    identifier = "r3m"
    path = "blog"
    actual = TrafficSpy::Url.ranked_request_types_for_url(identifier, path)
    expected = { "GET" => 3, "POST" => 1 } 
    assert_equal expected, actual
  end

  def teardown
    DatabaseCleaner.clean
  end
end
