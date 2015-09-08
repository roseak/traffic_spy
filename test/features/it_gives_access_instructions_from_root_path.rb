require "./test/test_helper"

module TrafficSpy
  class ItGivesAccessInstructionsFromRootPath < FeatureTest

    def test_it_gives_instructions_from_root
      visit '/'

      assert page.has_content?("This is not a valid URL.")
    end
  end
end
