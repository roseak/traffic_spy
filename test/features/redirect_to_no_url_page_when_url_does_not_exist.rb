require './test/test_helper'

class ReidrectsToNoUrlPage < FeatureTest
  def test_can_get_list_of_urls_from_most_to_least_requested
    visit('/sources/r3m/urls/hello')
    
    assert page.has_content?("URL Does Not Exist")
  end
end
