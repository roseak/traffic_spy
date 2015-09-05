require './test/test_helper'

class RedirectsToErrorWhenUrlHasNotBeenRequestedTest < FeatureTest
  def test_redirects_to_error 
    visit('/sources/r3m/helloo')

    assert page.has_content?("1")
  end
end
