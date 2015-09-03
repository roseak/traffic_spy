require './test/test_helper'

class UrlTest < Minitest::Test
  include Rack::Test::Methods 
  attr_reader :payload1, :payload2, :payload3, :payload4, :payload5, :payload6, :payload7

  def app
    TrafficSpy::Server
  end

  def setup
    attributes = {'identifier' => 'r3m', 'rootUrl' => 'http://r3m.com'}
    post('/sources', attributes)

    attributes2 = {'identifier' => '123', 'rootUrl' => 'http://123.com'}
    post('/sources', attributes2)

    @payload1 = '{
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

    @payload2 = '{
      "url":"http://r3m.com/blog",
      "requestedAt":"2013-01-16 21:38:28 -0700",
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

    @payload3 = '{
      "url":"http://r3m.com/blog",
      "requestedAt":"2013-04-16 21:38:28 -0700",
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

    @payload4 = '{
      "url":"http://r3m.com/pizza",
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

    @payload5 = '{
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

    @payload6 = '{
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

    @payload7 ='{
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
  end

  def test_can_find_all_urls_for_identifier
    skip
    
    setup
    post('/sources/r3m/data', payload1)
    post('/sources/r3m/data', payload2)
    post('/sources/r3m/data', payload3)
    post('/sources/r3m/data', payload4)
    post('/sources/r3m/data', payload5)
    post('/sources/r3m/data', payload6)
    post('/sources/123/data', payload7)

binding.pry
    identifier = 'r3m'
    assert_equal 7, TrafficSpy::Visit.all.size

    result = TrafficSpy::Url.urls_for_a_client(identifier)
    assert_equal 3, result
  end

  def app
    TrafficSpy::Server
  end

  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end
end
