require './test/test_helper'

module TrafficSpy
  class EventTest < Minitest::Test
    include Rack::Test::Methods

    def app
      TrafficSpy::Server
    end

    def setup
      DatabaseCleaner.start

      attributes1 = {'identifier' => 'r3m', 'rootUrl' => 'http://r3m.com'}
      attributes2 = {'identifier' => '123', 'rootUrl' => 'http://123.com'}

      Client.create(Client.prep(attributes1))
      Client.create(Client.prep(attributes2))

      payload6 = {"payload"=>
       "{\"url\":\"http://jumpstartlab.com/blog\",\"requestedAt\":\"2013-01-16 21:38:28 -0700\",\"respondedIn\":37,\"referredBy\":\"http://jumpstartlab.com\",\"requestType\":\"GET\",\"parameters\":[],\"eventName\": \"differentEvent\",\"userAgent\":\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17\",\"resolutionWidth\":\"1920\",\"resolutionHeight\":\"1280\",\"ip\":\"63.29.38.211\"}",
       "splat"=>[],
     "captures"=>["jumpstartlab"],
   "identifier"=>"jumpstartlab"}

      payload1 = {"payload"=>
       "{\"url\":\"http://jumpstartlab.com/blog\",\"requestedAt\":\"2013-01-16 21:38:28 -0700\",\"respondedIn\":37,\"referredBy\":\"http://jumpstartlab.com\",\"requestType\":\"GET\",\"parameters\":[],\"eventName\": \"socialLogin\",\"userAgent\":\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17\",\"resolutionWidth\":\"1920\",\"resolutionHeight\":\"1280\",\"ip\":\"63.29.38.211\"}",
       "splat"=>[],
     "captures"=>["jumpstartlab"],
   "identifier"=>"jumpstartlab"}

      payload2 = {"payload"=>
       "{\"url\":\"http://jumpstartlab.com/blog\",\"requestedAt\":\"2013-02-16 21:38:28 -0700\",\"respondedIn\":37,\"referredBy\":\"http://jumpstartlab.com\",\"requestType\":\"GET\",\"parameters\":[],\"eventName\": \"socialLogin\",\"userAgent\":\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17\",\"resolutionWidth\":\"1920\",\"resolutionHeight\":\"1280\",\"ip\":\"63.29.38.211\"}",
       "splat"=>[],
     "captures"=>["jumpstartlab"],
   "identifier"=>"jumpstartlab"}

      payload3 = {"payload"=>
       "{\"url\":\"http://jumpstartlab.com/blog\",\"requestedAt\":\"2013-03-16 21:38:28 -0700\",\"respondedIn\":37,\"referredBy\":\"http://jumpstartlab.com\",\"requestType\":\"GET\",\"parameters\":[],\"eventName\": \"boo\",\"userAgent\":\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17\",\"resolutionWidth\":\"1920\",\"resolutionHeight\":\"1280\",\"ip\":\"63.29.38.211\"}",
       "splat"=>[],
     "captures"=>["jumpstartlab"],
   "identifier"=>"jumpstartlab"}

      payload4 = {"payload"=>
       "{\"url\":\"http://jumpstartlab.com/blog\",\"requestedAt\":\"2013-04-16 21:38:28 -0700\",\"respondedIn\":37,\"referredBy\":\"http://jumpstartlab.com\",\"requestType\":\"GET\",\"parameters\":[],\"eventName\": \"boo\",\"userAgent\":\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17\",\"resolutionWidth\":\"1920\",\"resolutionHeight\":\"1280\",\"ip\":\"63.29.38.211\"}",
       "splat"=>[],
     "captures"=>["jumpstartlab"],
   "identifier"=>"jumpstartlab"}

   payload5 = {"payload"=>
    "{\"url\":\"http://jumpstartlab.com/image\",\"requestedAt\":\"2013-05-16 21:38:28 -0700\",\"respondedIn\":37,\"referredBy\":\"http://jumpstartlab.com\",\"requestType\":\"GET\",\"parameters\":[],\"eventName\": \"boo\",\"userAgent\":\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17\",\"resolutionWidth\":\"1920\",\"resolutionHeight\":\"1280\",\"ip\":\"63.29.38.211\"}",
    "splat"=>[],
  "captures"=>["jumpstartlab"],
  "identifier"=>"jumpstartlab"}

      post('/sources/r3m/data', payload6) 
      post('/sources/r3m/data', payload2)
      post('/sources/r3m/data', payload5)
      post('/sources/r3m/data', payload3)
      post('/sources/r3m/data', payload1)
      post('/sources/r3m/data', payload4)
    end

    def test_it_does_not_store_the_same_event_multiple_times
      expected_events=["boo", "differentEvent", "socialLogin"]
      actual = TrafficSpy::Event.all
      actual_events = actual.map { |event| event.name }

      assert_equal expected_events.sort, actual_events.sort
    end

    def test_it_can_rank_events_for_a_client
      expected = {"boo"=>3, "socialLogin"=>2, "differentEvent"=>1}
      result = Event.ranked_events_for_a_client('r3m')

      assert_equal expected, result
    end

    def test_it_can_find_the_most_requested_event_for_a_client
      expected = "boo"
      actual = Event.max('r3m')

      assert_equal expected, actual
    end

    def test_get_timestamps_for_events
      event = Event.find_by(name: "socialLogin")
      expected = [
        " 9:00pm", " 9:00pm"
      ]
      actual = Event.timestamps(event, 'r3m')
      assert_equal expected, actual
    end

    def test_sorts_timestamps_by_count
      event = Event.find_by(name: "socialLogin")
      expected = {
        " 9:00pm" => 2
      }
      actual = Event.sorted_timestamps(event, 'r3m')
      assert_equal expected, actual
    end

    def test_lists_all_sorted_timestmaps
      event = Event.find_by(name: "socialLogin")
      expected = {
        " 1:00am" => 0,
        " 2:00am" => 0,
        " 3:00am" => 0,
        " 4:00am" => 0,
        " 5:00am" => 0,
        " 6:00am" => 0,
        " 7:00am" => 0,
        " 8:00am" => 0,
        " 9:00am" => 0,
        "10:00am" => 0,
        "11:00am" => 0,
        "12:00pm" => 0,
        " 1:00pm" => 0,
        " 2:00pm" => 0,
        " 3:00pm" => 0,
        " 4:00pm" => 0,
        " 5:00pm" => 0,
        " 6:00pm" => 0,
        " 7:00pm" => 0,
        " 8:00pm" => 0,
        " 9:00pm" => 2,
        "10:00pm" => 0,
        "11:00pm" => 0,
        "12:00am" => 0,
      }
      actual = Event.all_sorted_timestamps(event, 'r3m')
      assert_equal expected, actual
    end

    def test_it_can_get_total_received_for_event
      event = Event.find_by(name: "socialLogin")
      expected = 2
      actual = Event.count_for_client(event, 'r3m')
      assert_equal expected, actual
    end

    def app
      TrafficSpy::Server
    end

    def teardown
      DatabaseCleaner.clean
    end

  end
end
