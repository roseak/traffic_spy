module TrafficSpy
  class WebBrowser < ActiveRecord::Base
    has_many :visits

    def self.web_browsers_for_a_client(identifier)
      Visit.visits_for_a_client(identifier).map do |visit|
        visit.web_browser
      end
    end

    def self.web_browsers_grouped(identifier)
      web_browsers_for_a_client(identifier).group_by do |browser|
        browser.browser
      end
    end

    def self.ranked_web_browser_visits(identifier)
      web_browsers_grouped(identifier).sort_by do |browser, visits|
        visits.length
      end.reverse.to_h
    end

    def self.ranked_web_browsers_with_count(identifier)
      ranked_web_browser_visits(identifier).map do |browser, visits|
        [browser, visits.length]
      end.to_h
    end

  end
end
