require "./test/test_helper"

class CanAccessUrlSpecificData < FeatureTest
  def test_can_access_url_specific_response_time
    click_link "URLs"
    assert_equal "/sources/r3m/urls", current_path
    click_link "blog"
    assert_equal "/sources/r3m/urls/blog", current_path

    assert page.has_content?("Response Time")
    assert page.has_content?("Min")
    assert page.has_content?("Max")
    assert page.has_content?("Average")
  end

  def test_can_access_url_specific_referrers_by_popularity
    click_link "URLs"
    assert_equal "/sources/r3m/urls", current_path
    click_link "blog"
    assert_equal "/sources/r3m/urls/blog", current_path

    assert page.has_content?("Referrer")
    assert page.has_content?("Count")
    assert page.has_content?("http://www.google.com")
    assert page.has_content?("http://www.bing.com")
  end

  def test_can_access_url_specific_browsers_by_popularity
    click_link "URLs"
    assert_equal "/sources/r3m/urls", current_path
    click_link "blog"
    assert_equal "/sources/r3m/urls/blog", current_path

    assert page.has_content?("Browser")
    assert page.has_content?("Count")
    assert page.has_content?("Chrome")
    assert page.has_content?("Firefox")
  end

  def test_can_access_url_specific_operating_systems_by_popularity
    click_link "URLs"
    assert_equal "/sources/r3m/urls", current_path
    click_link "blog"
    assert_equal "/sources/r3m/urls/blog", current_path

    assert page.has_content?("Operating System")
    assert page.has_content?("Count")
    assert page.has_content?("OS X 10.10.1")
    assert page.has_content?("Windows 7")
    assert page.has_content?("Linux i586")
  end

  def test_can_access_url_specific_request_types
    click_link "URLs"
    assert_equal "/sources/r3m/urls", current_path
    click_link "blog"
    assert_equal "/sources/r3m/urls/blog", current_path

    assert page.has_content?("GET")
  end
end
