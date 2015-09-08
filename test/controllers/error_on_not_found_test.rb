require './test/test_helper.rb'

module TrafficSpy
  class ErrorOnNotFoundTest < Minitest::Test
    include Rack::Test::Methods

    def app
      TrafficSpy::Server
    end

    def test_it_redirects_to_error_page_on_not_found
      get '/mulberry'

      assert_equal 404, last_response.status
      assert last_response.body.include? "Error"
    end

  end
end