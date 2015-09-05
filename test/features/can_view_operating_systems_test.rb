require './test/test_helper'

class CanAccessIdentifierStatPages < FeatureTest
  def test_can_get_to_operating_system_page
    visit('/sources/derp')
    click_link('Operating Systems')
    assert_equal '/sources/derp/os', current_path
  end
end
