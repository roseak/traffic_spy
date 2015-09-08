require "./test/test_helper"

class CanViewOperatingSystemsTest < FeatureTest
  def test_can_see_list_of_operating_systems
    visit("/sources/r3m")
    click_link("Operating Systems")
    assert_equal "/sources/r3m/os", current_path

    assert page.has_content?("OS")
    assert page.has_content?("Windows 7")
    assert page.has_content?("Linux i586")
    assert page.has_content?("OS X 10.10.1")
  end
end
