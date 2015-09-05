require './test/test_helper'

class CanAccessUrlSpecificData < FeatureTest
  def test_can_access_url_specific_data
    click_link "URLs"
    assert_equal "/sources/r3m/urls", current_path
    click_link "blog"
    assert_equal "/sources/r3m/urls/blog", current_path
  end
end
