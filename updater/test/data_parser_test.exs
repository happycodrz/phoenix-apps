defmodule Updater.DataParserTest do
  use ExUnit.Case
  alias Updater.DataParser

  describe ".parse_line" do
    test "without tags" do
      res =
        DataParser.parse_line(
          "https://github.com/boilercoding/crm [] Contact Management made with Elixir"
        )

      assert res ==
               {"https://github.com/boilercoding/crm", [], "Contact Management made with Elixir"}
    end

    test "without tags / description" do
      res = DataParser.parse_line("https://github.com/boilercoding/crm")
      assert res == {"https://github.com/boilercoding/crm", [], ""}
    end

    test "without tags, but description" do
      res = DataParser.parse_line("https://github.com/boilercoding/crm [] this is nice")
      assert res == {"https://github.com/boilercoding/crm", [], "this is nice"}
    end

    test "with tags and no description" do
      res = DataParser.parse_line("https://github.com/boilercoding/crm [crm, saas, nice stuff]")
      assert res == {"https://github.com/boilercoding/crm", ["crm", "nicestuff", "saas"], ""}
    end

    test "allows tags with some info" do
      res =
        DataParser.parse_line(
          "https://github.com/boilercoding/crm [quality:4 crm, saas, nice stuff]"
        )

      assert res ==
               {"https://github.com/boilercoding/crm", ["nicestuff", "quality:4crm", "saas"], ""}
    end
  end
end
