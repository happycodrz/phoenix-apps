defmodule UmbrellaFinderTest do
  use ExUnit.Case

  describe "adjust_for_proper_github_url" do
    test "ignores non-github urls" do
      assert UmbrellaFinder.adjust_for_proper_github_url("gitlab.com/user/repo") ==
               "gitlab.com/user/repo"

      assert UmbrellaFinder.adjust_for_proper_github_url("gitlab.com/user/repo/deeper/path") ==
               "gitlab.com/user/repo/deeper/path"
    end

    test "leaves top-level path untouched" do
      assert UmbrellaFinder.adjust_for_proper_github_url("github.com/user/repo") ==
               "github.com/user/repo"
    end

    test "adjusts deeper nested paths" do
      assert UmbrellaFinder.adjust_for_proper_github_url("github.com/user/repo/deeper/path") ==
               "github.com/user/repo/tree/master/deeper/path"
    end
  end
end
