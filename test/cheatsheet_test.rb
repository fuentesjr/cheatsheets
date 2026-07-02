# frozen_string_literal: true

require "minitest/autorun"
require "tmpdir"
require "fileutils"

load File.expand_path("../bin/cheatsheet", __dir__)

class CheatsheetTest < Minitest::Test
  def test_slugify
    assert_equal "postgresql", Cheatsheet.slugify("PostgreSQL")
    assert_equal "ruby-on-rails", Cheatsheet.slugify("Ruby on Rails")
    assert_equal "a-b", Cheatsheet.slugify("  a   b  ")
    assert_equal "pre-hyphenated", Cheatsheet.slugify("pre- hyphenated")
    assert_equal "", Cheatsheet.slugify("..")
    assert_equal "foo", Cheatsheet.slugify("../foo")
    assert_equal "a-b", Cheatsheet.slugify("a/b")
  end

  def test_extract_html_with_doctype_and_prose
    out = "Sure! Here's your cheatsheet:\n\n<!DOCTYPE html>\n<html><body>hi</body></html>\n\nLet me know if you need changes."
    assert_equal "<!DOCTYPE html>\n<html><body>hi</body></html>", Cheatsheet.extract_html(out)
  end

  def test_extract_html_without_doctype
    out = "prose <html lang=\"en\"><body>x</body></html> more prose"
    assert_equal "<html lang=\"en\"><body>x</body></html>", Cheatsheet.extract_html(out)
  end

  def test_extract_html_takes_last_closing_tag
    out = "<!DOCTYPE html><html><pre>&lt;/html&gt;</pre></html> trailing </html>"
    assert Cheatsheet.extract_html(out).end_with?("trailing </html>")
  end

  def test_extract_html_missing
    assert_nil Cheatsheet.extract_html("no markup here")
    assert_nil Cheatsheet.extract_html("<html> never closed")
    assert_nil Cheatsheet.extract_html(nil)
  end

  def test_parse_verdict_pass
    passed, issues = Cheatsheet.parse_verdict("VERDICT: PASS\nAll good.")
    assert passed
    assert_equal "All good.", issues
  end

  def test_parse_verdict_fail_with_issues
    passed, issues = Cheatsheet.parse_verdict("VERDICT: FAIL\n- missing copy buttons\n- broken toggle")
    refute passed
    assert_includes issues, "missing copy buttons"
    assert_includes issues, "broken toggle"
  end

  def test_parse_verdict_tolerates_leading_prose_and_case
    passed, = Cheatsheet.parse_verdict("Here is my review.\n verdict: pass \ndetails")
    assert passed
  end

  def test_parse_verdict_unparseable_is_failure
    passed, issues = Cheatsheet.parse_verdict("Looks fine to me!")
    refute passed
    assert_equal "Looks fine to me!", issues
  end

  def test_rebuild_index
    Dir.mktmpdir do |root|
      FileUtils.mkdir_p(File.join(root, "postgresql"))
      File.write(File.join(root, "postgresql", "index.html"), "<html></html>")
      FileUtils.mkdir_p(File.join(root, "minitest"))
      File.write(File.join(root, "minitest", "index.html"), "<html></html>")
      FileUtils.mkdir_p(File.join(root, "empty-dir"))
      FileUtils.mkdir_p(File.join(root, ".hidden"))
      File.write(File.join(root, ".hidden", "index.html"), "x")

      Cheatsheet.rebuild_index(root)

      html = File.read(File.join(root, "index.html"))
      assert_includes html, "<!DOCTYPE html>"
      assert_includes html, '<a href="postgresql/">postgresql</a>'
      assert_includes html, '<a href="minitest/">minitest</a>'
      refute_includes html, "empty-dir"
      refute_includes html, ".hidden"
      assert_operator html.index("minitest/"), :<, html.index("postgresql/"), "topics sorted"
    end
  end

  def test_topics
    Dir.mktmpdir do |root|
      FileUtils.mkdir_p(File.join(root, "rails"))
      File.write(File.join(root, "rails", "index.html"), "x")
      File.write(File.join(root, "index.html"), "root index ignored")
      assert_equal ["rails"], Cheatsheet.topics(root)
    end
  end
end
