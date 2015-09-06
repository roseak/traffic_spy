require './test/test_helper'

class CanViewAvergeResponseTime < FeatureTest
  def test_can_see_average_response_time
    visit('/sources/r3m')
    click_link('Average Response Time')

    assert_equal '/sources/r3m/responsetime', current_path
    assert page.has_content?("Average Response Time across all URLs")

  end
end
