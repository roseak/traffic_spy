require "./test/test_helper"

class ReidrectsToErrorWhenIdentiferDneTest < FeatureTest
  def test_redirects_to_error_when_identifier_dne
    visit("/sources/hello")

    assert page.has_content?("Identifer Does Not Exist")
  end
end
