module TrafficSpy

  class Server < Sinatra::Base
    get '/' do
      erb :index
    end

    post '/sources' do
      registration = Client.new(params) 

      if registration.save
        body "Successfully created"
      else
        if body task.error.full_messages.include("Already exits")
          status 403
          body "Already Exists"
        else
          status 400
          body "Missing information"
        end
      end
        
    end

    not_found do
      erb :error
    end
  end

end
