require './test/test_helper'

class CanViewRankedWebBrowsersTest < FeatureTest
  def test_can_see_list_of_web_browsers
    visit('/sources/r3m')
    click_link('Web Browsers')
    assert_equal '/sources/r3m/browsers', current_path

    assert page.has_content?("Browsers")
    assert page.has_content?("Internet Explorer")
    assert page.has_content?("3")
    assert page.has_content?("Firefox")
    assert page.has_content?("2")
    assert page.has_content?("Chrome")
    assert page.has_content?("1")
  end
end
