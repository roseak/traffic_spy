require './test/test_helper'

class CanViewOperatingSystemsTest < FeatureTest
  def test_can_see_list_of_operating_systems
    visit('/sources/r3m')
    click_link('Operating Systems')
    assert_equal '/sources/r3m/os', current_path

    assert page.has_content?("OS")
    assert page.has_content?("Windows 7")
    assert page.has_content?("3")
    assert page.has_content?("Windows 8.1")
    assert page.has_content?("2")
    assert page.has_content?("OS X 10.8.2")
    assert page.has_content?("1")
  end
end
