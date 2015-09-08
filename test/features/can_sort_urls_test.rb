require "./test/test_helper"

class UrlCanSortTest < FeatureTest
  def test_can_get_list_of_urls_from_most_to_least_requested
    visit("/sources/r3m")
    click_link("URLs")
    assert_equal "/sources/r3m/urls", current_path

    assert page.has_content?("blog")
    assert page.has_content?("3")
    assert page.has_content?("pizza")
    assert page.has_content?("2")
    assert page.has_content?("jonothy")
    assert page.has_content?("1")
  end
end
