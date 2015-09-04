require './test/test_helper'
module TrafficSpy
class DisplaysMostToLeastRequestedEventsTest < FeatureTest
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
     "{\"url\":\"http://jumpstartlab.com/blog\",\"requestedAt\":\"2013-02-16 21:38:28 -0700\",\"respondedIn\":37,\"referredBy\":\"http://jumpstartlab.com\",\"requestType\":\"GET\",\"parameters\":[],\"eventName\": \"socialLogin\",\"userAgent\":\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17\",\"resolutionWidth\":\"1920\",\"resolutionHeight\":\"1280\",\"ip\":\"63.29.38.211\"}",
     "splat"=>[],
   "captures"=>["jumpstartlab"],
 "identifier"=>"jumpstartlab"}   

    @payload2 = {"payload"=>
     "{\"url\":\"http://jumpstartlab.com/blog\",\"requestedAt\":\"2013-02-16 21:38:28 -0700\",\"respondedIn\":37,\"referredBy\":\"http://jumpstartlab.com\",\"requestType\":\"GET\",\"parameters\":[],\"eventName\": \"socialLogin\",\"userAgent\":\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17\",\"resolutionWidth\":\"1920\",\"resolutionHeight\":\"1280\",\"ip\":\"63.29.38.211\"}",
     "splat"=>[],
   "captures"=>["jumpstartlab"],
 "identifier"=>"jumpstartlab"}   

    @payload3 = {"payload"=>
     "{\"url\":\"http://jumpstartlab.com/blog\",\"requestedAt\":\"2013-02-16 21:38:28 -0700\",\"respondedIn\":37,\"referredBy\":\"http://jumpstartlab.com\",\"requestType\":\"GET\",\"parameters\":[],\"eventName\": \"boo\",\"userAgent\":\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17\",\"resolutionWidth\":\"1920\",\"resolutionHeight\":\"1280\",\"ip\":\"63.29.38.211\"}",
     "splat"=>[],
   "captures"=>["jumpstartlab"],
 "identifier"=>"jumpstartlab"}   

    @payload4 = {"payload"=>
     "{\"url\":\"http://jumpstartlab.com/blog\",\"requestedAt\":\"2013-02-16 21:38:28 -0700\",\"respondedIn\":37,\"referredBy\":\"http://jumpstartlab.com\",\"requestType\":\"GET\",\"parameters\":[],\"eventName\": \"boo\",\"userAgent\":\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17\",\"resolutionWidth\":\"1920\",\"resolutionHeight\":\"1280\",\"ip\":\"63.29.38.211\"}",
     "splat"=>[],
   "captures"=>["jumpstartlab"],
 "identifier"=>"jumpstartlab"}   

 @payload5 = {"payload"=>
  "{\"url\":\"http://jumpstartlab.com/blog\",\"requestedAt\":\"2013-02-16 21:38:28 -0700\",\"respondedIn\":37,\"referredBy\":\"http://jumpstartlab.com\",\"requestType\":\"GET\",\"parameters\":[],\"eventName\": \"boo\",\"userAgent\":\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17\",\"resolutionWidth\":\"1920\",\"resolutionHeight\":\"1280\",\"ip\":\"63.29.38.211\"}",
  "splat"=>[],
"captures"=>["jumpstartlab"],
"identifier"=>"jumpstartlab"}   


    @payload6 = {"payload"=>
     "{\"url\":\"http://jumpstartlab.com/blog\",\"requestedAt\":\"2013-02-16 21:38:28 -0700\",\"respondedIn\":37,\"referredBy\":\"http://jumpstartlab.com\",\"requestType\":\"GET\",\"parameters\":[],\"eventName\": \"Faz\",\"userAgent\":\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17\",\"resolutionWidth\":\"1920\",\"resolutionHeight\":\"1280\",\"ip\":\"63.29.38.211\"}",
     "splat"=>[],
   "captures"=>["jumpstartlab"],
 "identifier"=>"jumpstartlab"}   

  end

  def app
    TrafficSpy::Server
  end

  def test_can_get_list_of_urls_from_most_to_least_requested
    Client.create(Client.prep(attributes1))
    Client.create(Client.prep(attributes2))

    Payload.new(JSON.parse(payload1.fetch('payload')))
    Payload.new(JSON.parse(payload2.fetch('payload')))
    Payload.new(JSON.parse(payload3.fetch('payload')))
    Payload.new(JSON.parse(payload4.fetch('payload')))
    Payload.new(JSON.parse(payload5.fetch('payload')))
    Payload.new(JSON.parse(payload6.fetch('payload')))

    visit('/sources/r3m/events')

    assert page.has_content?("Faz")
    assert page.has_content?("boo")
    assert page.has_content?("socialLogin")
    assert page.has_content?("3")
    assert page.has_content?("2")
    assert page.has_content?("1")

  end

  def teardown
    DatabaseCleaner.clean
  end
end
end
