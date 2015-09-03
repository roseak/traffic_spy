require 'digest'

module TrafficSpy
  class Server < Sinatra::Base

    # This is testing for views
    
    get '/sources/:identifier' do |identifier|
      @params = {
        identifier: identifier,
        title: "Statistics",
      }

      erb :stats
    end

    get '/sources/:identifier/urls' do |identifier|
      @params = {
        identifier: identifier,
        title: "URLs",
        header: "URL",
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

      erb :list
    end

    get '/sources/:identifier/browsers' do |identifier|
      @params = {
        identifier: identifier,
        title: "Web Browsers",
        header: "Browser",
        data: {
          "SAFARI" => 10,
          "CHROME" => 3,
          "MOZILLA" => 9,
        }
      }

      erb :list
    end

    get '/sources/:identifier/os' do |identifier|
      @params = {
        identifier: identifier,
        title: "Operating Systems",
        header: "OS",
        data: {
          "OSX YOSEMITE" => 10,
          "WINDOWS XP" => 5,
          "UBUNTU LINUX" => 4,
          "WINDOWS 2000" => 3,
        }
      }

      erb :list
    end

    get '/sources/:identifier/resolution' do |identifier|
      @params = {
        identifier: identifier,
        title: "Screen Resolution",
        header: "Resolution",
        data: {
          "1920 × 1080" => 10,
          "640 × 480" => 5,
          "1440 × 1024" => 4,
          "100 × 100" => 3,
        }
      }

      erb :list
    end
  end
end
