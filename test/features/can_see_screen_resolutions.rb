require './test/test_helper'

class CanSeeScreenResolutionsTest < FeatureTest
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

    payload2 = '{
      "url":"http://r3m.com/blog",
      "requestedAt":"2013-01-16 21:38:28 -0700",
      "respondedIn":37,
      "referredBy":"http://r3m.com",
      "requestType":"GET",
      "parameters":[],
      "eventName": "socialLogin",
      "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
      "resolutionWidth":"1366",
      "resolutionHeight":"768",
      "ip":"63.29.38.211"
    }'

    payload3 = '{
      "url":"http://r3m.com/blog",
      "requestedAt":"2013-04-16 21:38:28 -0700",
      "respondedIn":37,
      "referredBy":"http://r3m.com",
      "requestType":"GET",
      "parameters":[],
      "eventName": "socialLogin",
      "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
      "resolutionWidth":"1366",
      "resolutionHeight":"768",
      "ip":"63.29.38.211"
    }'

    payload4 = '{
      "url":"http://r3m.com/pizza",
      "requestedAt":"2013-02-16 21:38:28 -0700",
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

    payload5 = '{
      "url":"http://r3m.com/jonothy",
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

    payload6 = '{
      "url":"http://r3m.com/pizza",
      "requestedAt":"2013-07-16 21:38:28 -0700",
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

    payload7 = '{
      "url":"http://123.com/pizza",
      "requestedAt":"2013-07-16 21:38:28 -0700",
      "respondedIn":37,
      "referredBy":"http://123.com",
      "requestType":"GET",
      "parameters":[],
      "eventName": "socialLogin",
      "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
      "resolutionWidth":"1920",
      "resolutionHeight":"1280",
      "ip":"63.29.38.211"
    }'

    post('/sources/r3m/data', {'payload' => payload1})
    post('/sources/r3m/data', {'payload' => payload2})
    post('/sources/r3m/data', {'payload' => payload3})
    post('/sources/r3m/data', {'payload' => payload4})
    post('/sources/r3m/data', {'payload' => payload5})
    post('/sources/r3m/data', {'payload' => payload6})
    post('/sources/123/data', {'payload' => payload7})
  end

  def test_can_get_list_of_urls_from_most_to_least_requested
    visit('/sources/r3m')
    click_link('Screen Resolutions')
    assert_equal "/sources/r3m/screen_resolutions", current_path

    assert page.has_content?(Screen Resolutions)
    assert page.has_content?("1920 x 1280")
    assert page.has_content?("3")
    assert page.has_content?("1366 x 768")
    assert page.has_content?("2")
    assert page.has_content?("800 x 600")
    assert page.has_content?("1")
  end

  def teardown
    DatabaseCleaner.clean
  end
end
