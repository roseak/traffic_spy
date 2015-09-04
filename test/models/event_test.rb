require './test/test_helper'
module TrafficSpy
  class EventTest < Minitest::Test
    include Rack::Test::Methods

    attr_reader :payload1, :payload2, :payload3, :payload4, :payload5, :payload6,
                :attributes1, :attributes2

    def app
      TrafficSpy::Server
    end

    def setup
      DatabaseCleaner.start
      @attributes1 = {'identifier' => 'r3m', 'rootUrl' => 'http://r3m.com'}
      @attributes2 = {'identifier' => '123', 'rootUrl' => 'http://123.com'}

      @payload1 = {"payload"=>
       "{\"url\":\"http://jumpstartlab.com/blog\",\"requestedAt\":\"2013-01-16 21:38:28 -0700\",\"respondedIn\":37,\"referredBy\":\"http://jumpstartlab.com\",\"requestType\":\"GET\",\"parameters\":[],\"eventName\": \"socialLogin\",\"userAgent\":\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17\",\"resolutionWidth\":\"1920\",\"resolutionHeight\":\"1280\",\"ip\":\"63.29.38.211\"}",
       "splat"=>[],
     "captures"=>["jumpstartlab"],
   "identifier"=>"jumpstartlab"}   

      @payload2 = {"payload"=>
       "{\"url\":\"http://jumpstartlab.com/blog\",\"requestedAt\":\"2013-02-16 21:38:28 -0700\",\"respondedIn\":37,\"referredBy\":\"http://jumpstartlab.com\",\"requestType\":\"GET\",\"parameters\":[],\"eventName\": \"socialLogin\",\"userAgent\":\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17\",\"resolutionWidth\":\"1920\",\"resolutionHeight\":\"1280\",\"ip\":\"63.29.38.211\"}",
       "splat"=>[],
     "captures"=>["jumpstartlab"],
   "identifier"=>"jumpstartlab"}   

      @payload3 = {"payload"=>
       "{\"url\":\"http://jumpstartlab.com/blog\",\"requestedAt\":\"2013-03-16 21:38:28 -0700\",\"respondedIn\":37,\"referredBy\":\"http://jumpstartlab.com\",\"requestType\":\"GET\",\"parameters\":[],\"eventName\": \"boo\",\"userAgent\":\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17\",\"resolutionWidth\":\"1920\",\"resolutionHeight\":\"1280\",\"ip\":\"63.29.38.211\"}",
       "splat"=>[],
     "captures"=>["jumpstartlab"],
   "identifier"=>"jumpstartlab"}   

      @payload4 = {"payload"=>
       "{\"url\":\"http://jumpstartlab.com/blog\",\"requestedAt\":\"2013-04-16 21:38:28 -0700\",\"respondedIn\":37,\"referredBy\":\"http://jumpstartlab.com\",\"requestType\":\"GET\",\"parameters\":[],\"eventName\": \"boo\",\"userAgent\":\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17\",\"resolutionWidth\":\"1920\",\"resolutionHeight\":\"1280\",\"ip\":\"63.29.38.211\"}",
       "splat"=>[],
     "captures"=>["jumpstartlab"],
   "identifier"=>"jumpstartlab"}   

   @payload5 = {"payload"=>
    "{\"url\":\"http://jumpstartlab.com/image\",\"requestedAt\":\"2013-05-16 21:38:28 -0700\",\"respondedIn\":37,\"referredBy\":\"http://jumpstartlab.com\",\"requestType\":\"GET\",\"parameters\":[],\"eventName\": \"boo\",\"userAgent\":\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17\",\"resolutionWidth\":\"1920\",\"resolutionHeight\":\"1280\",\"ip\":\"63.29.38.211\"}",
    "splat"=>[],
  "captures"=>["jumpstartlab"],
  "identifier"=>"jumpstartlab"}   


      @payload6 = {"payload"=>
       "{\"url\":\"http://jumpstartlab.com/blog\",\"requestedAt\":\"2013-06-16 21:38:28 -0700\",\"respondedIn\":37,\"referredBy\":\"http://jumpstartlab.com\",\"requestType\":\"GET\",\"parameters\":[],\"eventName\": \"Faz\",\"userAgent\":\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17\",\"resolutionWidth\":\"1920\",\"resolutionHeight\":\"1280\",\"ip\":\"63.29.38.211\"}",
       "splat"=>[],
     "captures"=>["jumpstartlab"],
   "identifier"=>"jumpstartlab"}   
    end

    def test_can_find_events_for_a_client
      Client.create(Client.prep(attributes1))
      Client.create(Client.prep(attributes2))

      post('/sources/r3m/data', payload2)
      post('/sources/r3m/data', payload5)
      post('/sources/r3m/data', payload3)
      post('/sources/r3m/data', payload1)
      post('/sources/r3m/data', payload4)
      post('/sources/123/data', payload6)

      result = Event.events_for_a_client('r3m')

      assert_equal 2, result.size
      assert_equal 2, result['socialLogin']
    end

    def app
      TrafficSpy::Server
    end

    def teardown
      DatabaseCleaner.clean
    end

  end
end
