# frozen_string_literal: true

require "fileutils"
require "minitest/autorun"
require "open3"
require "tmpdir"

class UpdateTeamsFormulaTest < Minitest::Test
  ROOT = File.expand_path("..", __dir__)
  SCRIPT = File.join(ROOT, "scripts/update-teams-formula.rb")
  FORMULA = File.join(ROOT, "Formula/teams-cli.rb")
  REPO = "aberoham/ms-teams-cli"
  TARGETS = %w[
    aarch64-apple-darwin
    x86_64-apple-darwin
    aarch64-unknown-linux-musl
    x86_64-unknown-linux-musl
  ].freeze

  def setup
    @dir = Dir.mktmpdir
    @formula = File.join(@dir, "teams-cli.rb")
    File.write(@formula, File.read(FORMULA))
  end

  def teardown
    FileUtils.remove_entry(@dir)
  end

  def checksums_for(tag, skip: nil)
    path = File.join(@dir, "checksums-#{tag}.txt")
    lines = TARGETS.reject { |t| t == skip }.each_with_index.map do |target, i|
      "#{i.to_s * 64} teams-#{tag}-#{target}.tar.gz"
    end
    File.write(path, "#{lines.join("\n")}\n")
    path
  end

  def run_script(tag, repo: REPO, checksums: checksums_for(tag), env: {})
    Open3.capture3(env, "ruby", SCRIPT, tag, repo, checksums, @formula)
  end

  def test_points_every_target_at_the_fork_prerelease
    _, err, status = run_script("v0.7.1-alpha.1")
    assert status.success?, err

    formula = File.read(@formula)
    assert_match(/^  version "0\.7\.1-alpha\.1"$/, formula)
    TARGETS.each do |target|
      assert_includes formula,
                      "https://github.com/#{REPO}/releases/download/v0.7.1-alpha.1/" \
                      "teams-v0.7.1-alpha.1-#{target}.tar.gz"
    end
    refute_includes formula, "osodevops"
    assert_equal 1, formula.scan(/^\s*version /).length
  end

  def test_refuses_a_stable_tag
    _, err, status = run_script("v0.7.1")
    refute status.success?
    assert_match(/expected vX\.Y\.Z-prerelease/, err)
  end

  def test_refuses_the_upstream_repository
    _, err, status = run_script("v0.7.1-alpha.1", repo: "osodevops/ms-teams-cli")
    refute status.success?
    assert_match(/unexpected release repository/, err)
  end

  def test_refuses_a_missing_checksum
    tag = "v0.7.1-alpha.1"
    _, err, status = run_script(tag, checksums: checksums_for(tag, skip: "x86_64-apple-darwin"))
    refute status.success?
    assert_match(/missing checksum for teams-#{tag}-x86_64-apple-darwin/, err)
  end

  def test_refuses_an_unattended_downgrade_but_allows_a_named_rollback
    assert run_script("v0.7.1-alpha.2")[2].success?

    _, err, status = run_script("v0.7.1-alpha.1")
    refute status.success?
    assert_match(/refusing to move teams-cli from 0\.7\.1-alpha\.2 down/, err)

    _, err, status = run_script("v0.7.1-alpha.1", env: { "ALLOW_DOWNGRADE" => "true" })
    assert status.success?, err
    assert_match(/^  version "0\.7\.1-alpha\.1"$/, File.read(@formula))
  end

  def test_rerunning_the_same_release_changes_nothing
    assert run_script("v0.7.1-alpha.1")[2].success?
    before = File.read(@formula)
    assert run_script("v0.7.1-alpha.1")[2].success?
    assert_equal before, File.read(@formula)
  end
end
