require './test/test_helper.rb'

module TrafficSpy
  class NavigateToUrlWithNoHitsTest < Minitest::Test
    include Rack::Test::Methods

    def app
      TrafficSpy::Server
    end

    def test_it_redirects_to_error_on_url_with_no_hits
      get '/sources/r3m/urls/high_scores'

      assert last_response.body =~ /Url has not been requested/
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
        "referredBy":"http://www.google.com",
        "requestType":"GET",
        "parameters":[],
        "eventName": "partyTime",
        "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2227.1 Safari/537.36",
        "resolutionWidth":"1920",
        "resolutionHeight":"1280",
        "ip":"63.29.38.211"
      }'

      post('/sources/r3m/data', {'payload' => payload1})

    end

    def teardown
      DatabaseCleaner.clean
    end
  end
end

