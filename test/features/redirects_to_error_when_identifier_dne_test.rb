require './test/test_helper'

class ReidrectsToErrorWhenIdentiferDneTest < FeatureTest
  def test_can_get_list_of_urls_from_most_to_least_requested
    visit('/sources/hello')
    
    save_and_open_page
    assert page.has_content?("Identifer Does Not Exist")
  end
end
