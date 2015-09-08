require "./test/test_helper"

class CanAccessIdentifierStatPages < FeatureTest
  def test_the_page_has_stuff
    assert page.has_content?("Statistics")
    assert page.has_content?("r3m")
    within(:css, ".list-group") do
      assert page.has_content?("URLs")
      assert page.has_content?("Browsers")
      assert page.has_content?("Operating Systems")
      assert page.has_content?("Screen Resolutions")
      assert page.has_content?("Average Response Time")
      assert page.has_content?("Events")
    end
  end
end
