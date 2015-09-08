require "./test/test_helper"

class CanSeeScreenResolutionsTest < FeatureTest
  def test_can_get_list_of_screen_resolutions
    visit("/sources/r3m")
    click_link("Screen Resolutions")
    assert_equal "/sources/r3m/resolution", current_path

    assert page.has_content?("Screen Resolutions")
    assert page.has_content?("1920x1280")
    assert page.has_content?("3")
    assert page.has_content?("1366x768")
    assert page.has_content?("2")
    assert page.has_content?("800x600")
    assert page.has_content?("1")
  end
end
