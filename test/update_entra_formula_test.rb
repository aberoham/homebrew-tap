# frozen_string_literal: true

require "fileutils"
require "minitest/autorun"
require "open3"
require "tmpdir"

# The updater runs under `brew ruby` for Homebrew's Version class, whose
# vendored Ruby lacks minitest, so these tests run under the system Ruby and
# call the script as a subprocess.
class UpdateEntraFormulaTest < Minitest::Test
  ROOT = File.expand_path("..", __dir__)
  SCRIPT = File.join(ROOT, "scripts/update-entra-formula.rb")
  BREW = ENV.fetch("HOMEBREW_BREW_FILE", "brew")
  # The bootstrap formula, frozen so the tests do not depend on whichever
  # release the live formula currently publishes.
  FORMULA = File.join(__dir__, "fixtures/entra-0.0.1.rb")
  REPO = "aberoham/ms-entra-cli"
  TARGETS = %w[
    aarch64-apple-darwin
    x86_64-apple-darwin
    aarch64-unknown-linux-musl
    x86_64-unknown-linux-musl
  ].freeze

  def setup
    @dir = Dir.mktmpdir
    @formula = File.join(@dir, "entra.rb")
    File.write(@formula, File.read(FORMULA))
  end

  def teardown
    FileUtils.remove_entry(@dir)
  end

  def checksums_for(tag, skip: nil)
    path = File.join(@dir, "checksums-#{tag}.txt")
    lines = TARGETS.reject { |t| t == skip }.each_with_index.map do |target, i|
      "#{(i + 1).to_s * 64}  entra-#{tag}-#{target}.tar.gz"
    end
    # The release also lists the Windows archive; the updater must ignore it.
    lines << "#{'f' * 64}  entra-#{tag}-x86_64-pc-windows-msvc.zip"
    File.write(path, "#{lines.join("\n")}\n")
    path
  end

  def run_script(tag, repo: REPO, checksums: checksums_for(tag), flags: [])
    Open3.capture3(BREW, "ruby", "--", SCRIPT, *flags, tag, repo, checksums, @formula)
  end

  def test_points_every_target_at_a_stable_release
    _, err, status = run_script("v0.1.0")
    assert status.success?, err

    formula = File.read(@formula)
    assert_match(/^  version "0\.1\.0"$/, formula)
    TARGETS.each_with_index do |target, i|
      assert_includes formula,
                      "url \"https://github.com/#{REPO}/releases/download/v0.1.0/" \
                      "entra-v0.1.0-#{target}.tar.gz\"\n"
      assert_includes formula, "sha256 \"#{(i + 1).to_s * 64}\""
    end
    refute_includes formula, "v0.0.1"
    refute_includes formula, "0" * 64
    assert_equal 1, formula.scan(/^\s*version /).length
  end

  def test_accepts_prerelease_tags
    %w[v0.2.0-alpha.1 v0.2.0-beta.1 v0.2.0-rc.1 v0.2.0].each do |tag|
      _, err, status = run_script(tag)
      assert status.success?, "#{tag}: #{err}"
    end
    assert_match(/^  version "0\.2\.0"$/, File.read(@formula))
  end

  def test_refuses_malformed_or_unsupported_tags
    %w[0.1.0 v0.1 v0.1.0-preview.1 v0.1.0-pre.1 v0.1.0-rc.1+build v0.1.0+build].each do |tag|
      _, err, status = run_script(tag)
      refute status.success?, "#{tag} was accepted"
      assert_match(/invalid release tag/, err)
    end
  end

  def test_refuses_another_repository
    _, err, status = run_script("v0.1.0", repo: "someone-else/ms-entra-cli")
    refute status.success?
    assert_match(/unexpected release repository/, err)
  end

  def test_refuses_a_missing_checksum
    tag = "v0.1.0"
    _, err, status = run_script(tag, checksums: checksums_for(tag, skip: "x86_64-apple-darwin"))
    refute status.success?
    assert_match(/missing checksum for entra-#{tag}-x86_64-apple-darwin/, err)
  end

  def test_refuses_a_malformed_checksum_line
    path = File.join(@dir, "bad.txt")
    File.write(path, "abc entra-v0.1.0-aarch64-apple-darwin.tar.gz extra\n")
    _, err, status = run_script("v0.1.0", checksums: path)
    refute status.success?
    assert_match(/malformed checksum line/, err)
  end

  # Homebrew orders a release candidate below its final release. An
  # unattended run must never replace 0.2.0 with 0.2.0-rc.1.
  def test_refuses_an_unattended_downgrade_but_allows_a_named_rollback
    assert run_script("v0.2.0")[2].success?

    _, err, status = run_script("v0.2.0-rc.1")
    refute status.success?
    assert_match(/refusing to move entra from 0\.2\.0 down to 0\.2\.0-rc\.1/, err)

    _, err, status = run_script("v0.1.0", flags: ["--allow-downgrade"])
    assert status.success?, err
    assert_match(/^  version "0\.1\.0"$/, File.read(@formula))
  end

  def test_rerunning_the_same_release_changes_nothing
    assert run_script("v0.1.0")[2].success?
    before = File.read(@formula)
    assert run_script("v0.1.0")[2].success?
    assert_equal before, File.read(@formula)
  end

  def test_refuses_to_run_outside_brew_ruby
    _, err, status = Open3.capture3("ruby", SCRIPT, "v0.1.0", REPO, checksums_for("v0.1.0"), @formula)
    refute status.success?
    assert_match(/brew ruby/, err)
  end
end
