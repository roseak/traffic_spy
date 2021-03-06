require "./test/test_helper"

class RegisterTest < Minitest::Test
  include Rack::Test::Methods

  attr_reader :payload

  def app
    TrafficSpy::Server
  end

  def setup
    DatabaseCleaner.start
    @payload = { "payload" =>
                 "{\"url\":\"http://jumpstartlab.com/blog\",\"requestedAt\":"\
                 "\"2013-02-16 21:38:28 -0700\",\"respondedIn\":37,\""\
                 "referredBy\":\"http://jumpstartlab.com\",\"requestType\":"\
                 "\"GET\",\"parameters\":[],\"eventName\": \"socialLogin\","\
                 "\"userAgent\":\"Mozilla/5.0 (Macintosh; Intel Mac OS X "\
                 "10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/"\
                 "24.0.1309.0 Safari/537.17\",\"resolutionWidth\":\"1920\","\
                 "\"resolutionHeight\":\"1280\",\"ip\":\"63.29.38.211\"}",
                 "splat" => [],
                 "captures" => ["jumpstartlab"],
                 "identifier" => "jumpstartlab" }
  end

  def test_gets_200_from_good_request
    setup
    attributes = { "identifier" => "r3m", "rootUrl" => "http://r3m.com" }
    # {"identifier"=>"apple", "rootUrl"=>"http://apple.com"}

    post("/sources", attributes)

    post("/sources/r3m/data", payload)
    # post("/sources/r3m/data", {payload: payload})

    url = TrafficSpy::Url.find(1)
    referral = TrafficSpy::Referral.find(1)
    event = TrafficSpy::Event.find(1)
    user_env = TrafficSpy::UserEnv.find(1)
    request_type = TrafficSpy::RequestType.find(1)
    visit = TrafficSpy::Visit.find(1)
    client = TrafficSpy::Client.find(1)

    assert_equal 200, last_response.status

    assert_equal client, TrafficSpy::Client.find(url.client_id)
    assert_equal referral, TrafficSpy::Referral.find(visit.referral_id)
    assert_equal event, TrafficSpy::Event.find(visit.event_id)
    assert_equal user_env, TrafficSpy::UserEnv.find(visit.user_env_id)
    assert_equal request_type, TrafficSpy::RequestType.
      find(visit.request_type_id)
  end

  def test_gets_400_for_missing_payload
    attributes = { "identifier" => "r3m", "rootUrl" => "http://r3m.com" }
    post("/sources", attributes)

    post("/sources/r3m/data", {})

    assert_equal 400, last_response.status
    assert_equal "Payload is empty", last_response.body
  end

  def test_gets_400_for_submitting_nothing
    attributes = { "identifier" => "r3m", "rootUrl" => "http://r3m.com" }
    post("/sources", attributes)

    post("/sources/r3m/data")

    assert_equal 400, last_response.status
    assert_equal "Payload is empty", last_response.body
  end

  def test_gets_400_for_submitting_another_nothing
    attributes = { "identifier" => "r3m", "rootUrl" => "http://r3m.com" }
    post("/sources", attributes)

    payload = { "payload" => "{}" }

    post("/sources/r3m/data", payload)

    assert_equal 400, last_response.status
    assert_equal "Payload is empty", last_response.body
  end

  def test_gets_403_for_duplicate_payload
    attributes = { "identifier" => "r3m", "rootUrl" => "http://r3m.com" }
    post("/sources", attributes)

    post("/sources/r3m/data", payload)
    post("/sources/r3m/data", payload)

    assert_equal 403, last_response.status
    assert_equal "Already received request", last_response.body
  end

  def test_gets_403_not_registered
    attributes = { "identifier" => "r3m", "rootUrl" => "http://r3m.com" }
    post("/sources", attributes)

    post("/sources/123/data", payload)

    assert_equal 403, last_response.status
    assert_equal "Application not registered", last_response.body
  end

  def teardown
    DatabaseCleaner.clean
  end
end
