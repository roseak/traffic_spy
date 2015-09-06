require './test/test_helper'

class VisitTest < Minitest::Test
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
      "respondedIn":85,
      "referredBy":"http://www.google.com",
      "requestType":"GET",
      "parameters":[],
      "eventName": "socialLogin",
      "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2227.1 Safari/537.36",
      "resolutionWidth":"1920",
      "resolutionHeight":"1280",
      "ip":"63.29.38.205"
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
      "ip":"63.29.38.206"
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
      "ip":"63.29.38.207"
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
      "ip":"63.29.38.208"
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
      "ip":"63.29.38.209"
    }'

    payload6 = '{
      "url":"http://r3m.com/pizza",
      "requestedAt":"2013-07-16 21:38:28 -0700",
      "respondedIn":20,
      "referredBy":"",
      "requestType":"GET",
      "parameters":[],
      "eventName": "socialLogin",
      "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
      "resolutionWidth":"1920",
      "resolutionHeight":"1280",
      "ip":"63.29.38.210"
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
      "ip":"63.29.38.212"
    }'

    post('/sources/r3m/data', {'payload' => payload2})
    post('/sources/r3m/data', {'payload' => payload5})
    post('/sources/r3m/data', {'payload' => payload3})
    post('/sources/r3m/data', {'payload' => payload1})
    post('/sources/123/data', {'payload' => payload7})
    post('/sources/r3m/data', {'payload' => payload4})
    post('/sources/r3m/data', {'payload' => payload6})
    post('/sources/r3m/data', {'payload' => payload8})

    @visits_r3m = TrafficSpy::Visit.visits_for_a_client("r3m")
    @visits_123 = TrafficSpy::Visit.visits_for_a_client("123")
  end

  def test_it_has_right_number_of_visits
    assert_equal 8, TrafficSpy::Visit.count
  end

  def test_it_has_right_number_of_visits_for_a_client
    assert_equal 7, @visits_r3m.length
    assert_equal 1, @visits_123.length
  end

  def test_urls_match_up_via_visits_for_a_client
    assert @visits_r3m.all? { |visit| visit.url.url =~ /r3m/ }
    assert @visits_123.all? { |visit| visit.url.url =~ /123/ }
  end

  def test_it_stores_proper_ids_for_all_related_objects
    visit = TrafficSpy::Visit.find_by(responded_in: "37")

    assert_equal TrafficSpy::Url.find(visit.url_id).url, "http://r3m.com/blog"
    assert_equal TrafficSpy::Referral.find(visit.referral_id).referred_by, "http://www.bing.com"
    assert_equal TrafficSpy::Event.find(visit.event_id).name, "socialLogin"
    assert_equal TrafficSpy::RequestType.find(visit.request_type_id).request_type, "POST"
    assert_equal TrafficSpy::Resolution.find(visit.resolution_id).resolution, "1920x1280"
    assert_equal TrafficSpy::WebBrowser.find(visit.web_browser_id).browser, "Internet Explorer"
    assert_equal TrafficSpy::OperatingSystem.find(visit.operating_system_id).operating_system, "Windows 7"
  end

  def teardown
    DatabaseCleaner.clean
  end
end
