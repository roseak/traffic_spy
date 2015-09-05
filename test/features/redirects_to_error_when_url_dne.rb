require './test/test_helper'

class ReidrectsToErrorWhenUrlDneTest < FeatureTest
  def test_redirects_to_Error_when_url_dne
    visit('/sources/r3m/urls/some_url')
    
    assert page.has_content?("Url has not been requested")
  end
end
