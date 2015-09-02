require './test/test_helper'


class RegisterTest < FeatureTest
  include Rack::Test::Methods

  def app
    TrafficSpy::Server
  end

  def test_can_register_with_good_params 
     response = `curl -i -d 'identifier=jumpstartlab&rootUrl=http://jumpstartlab.com'  http://localhost:9393/sources`
     result = response.split("\r\n")

    assert_equal "HTTP/1.1 200 OK ", result.first 
#    assert_equal "Successfully created", result.something
  end

  def test_gets_400_from_bad_input_params
     response = `curl -i -d 'rootUrl=http://jumpstartlab.com'  http://localhost:9393/sources`
     result = response.split("\r\n")

    assert_equal "HTTP/1.1 400 not good", result.first 
  end

end
