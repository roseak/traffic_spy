module TrafficSpy

  class Server < Sinatra::Base
    get '/' do
      erb :index
    end

    post '/sources' do
      client = Client.new(params) 

      if client.save
        body "Successfully created"
      elsif client.errors.full_messages.any? { |error| error.include?("blank") }
          status 400
      end
        
    end

    not_found do
      erb :error
    end
  end

end
