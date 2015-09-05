require './test/test_helper'

class CanAccessUrlSpecificData < FeatureTest
  def test_can_access_url_specific_response_time
    click_link "URLs"
    assert_equal "/sources/r3m/urls", current_path
    click_link "blog"
    assert_equal "/sources/r3m/urls/blog", current_path

    assert page.has_content?("URL Specific Data")
    assert page.has_content?("Shortest Response Time")
    assert page.has_content?("Longest Response Time")
    assert page.has_content?("Average Response Time")
  end

  def test_can_access_url_specific_referrers_by_popularity
    click_link "URLs"
    assert_equal "/sources/r3m/urls", current_path
    click_link "blog"
    assert_equal "/sources/r3m/urls/blog", current_path

    save_and_open_page
    assert page.has_content?("Referrer")
    assert page.has_content?("Count")
    assert page.has_content?("http://www.google.com")
    assert page.has_content?("http://www.bing.com")
    assert page.has_content?("2")
    assert page.has_content?("1")
  end
end