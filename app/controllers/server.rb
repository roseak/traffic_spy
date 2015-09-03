require 'digest'

module TrafficSpy
  class Server < Sinatra::Base

    # This is testing for views
    
    get '/sources/:identifier/urls' do |identifier|
      @params = {
        identifier: identifier,
        title: "URLs",
        data: {
          "#{identifier}/blog" => 10,
          "#{identifier}/something" => 10,
          "#{identifier}/blog" => 9,
          "#{identifier}/abas" => 8,
          "#{identifier}/lkjsdf" => 7,
          "#{identifier}/lkja" => 5,
          "#{identifier}/lkj" => 4,
        }
      }

      erb :urls
    end
  end
end
