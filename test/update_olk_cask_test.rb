# frozen_string_literal: true

require "fileutils"
require "minitest/autorun"
require "open3"
require "tmpdir"

class UpdateOlkCaskTest < Minitest::Test
  SCRIPT = File.expand_path("../scripts/update-olk-cask.rb", __dir__)
  REPO = "aberoham/olkcli"
  ARCHES = %w[arm64 amd64].freeze

  def setup
    @dir = Dir.mktmpdir
    @cask = File.join(@dir, "olk.rb")
  end

  def teardown
    FileUtils.remove_entry(@dir)
  end

  def checksums_for(tag, skip: nil)
    version = tag.delete_prefix("v")
    path = File.join(@dir, "checksums-#{tag}.txt")
    lines = ARCHES.reject { |a| a == skip }.each_with_index.map do |arch, i|
      "#{(i + 1).to_s * 64}  olk_#{version}_darwin_#{arch}.tar.gz"
    end
    lines << "#{'9' * 64}  olk_#{version}_linux_amd64.tar.gz"
    File.write(path, "#{lines.join("\n")}\n")
    path
  end

  def run_script(tag, repo: REPO, checksums: checksums_for(tag), env: {})
    Open3.capture3(env, "ruby", SCRIPT, tag, repo, checksums, @cask)
  end

  def test_writes_a_cask_for_both_mac_architectures
    _, err, status = run_script("v1.14.1-alpha.1")
    assert status.success?, err

    cask = File.read(@cask)
    assert_match(/^  version "1\.14\.1-alpha\.1"$/, cask)
    assert_includes cask, %(sha256 "#{'1' * 64}")
    assert_includes cask, %(sha256 "#{'2' * 64}")
    assert_includes cask,
                    "https://github.com/#{REPO}/releases/download/v\#{version}/olk_\#{version}_darwin_arm64.tar.gz"
    assert_includes cask, "com.apple.quarantine"
    refute_includes cask, "rlrghb"

    _, err, status = Open3.capture3("ruby", "-c", @cask)
    assert status.success?, err
  end

  def test_refuses_a_stable_tag_and_other_labels
    %w[v1.14.1 v1.14.1-preview.1 v1.14.1-alpha].each do |tag|
      _, err, status = run_script(tag)
      refute status.success?, "#{tag} was accepted"
      assert_match(/invalid release tag/, err)
    end
  end

  def test_refuses_the_upstream_repository
    _, err, status = run_script("v1.14.1-alpha.1", repo: "rlrghb/olkcli")
    refute status.success?
    assert_match(/unexpected release repository/, err)
  end

  def test_refuses_a_missing_checksum
    tag = "v1.14.1-alpha.1"
    _, err, status = run_script(tag, checksums: checksums_for(tag, skip: "amd64"))
    refute status.success?
    assert_match(/missing checksum for olk_1\.14\.1-alpha\.1_darwin_amd64/, err)
  end

  def test_refuses_malformed_checksum_files
    tag = "v1.14.1-alpha.1"
    version = tag.delete_prefix("v")
    {
      "#{'1' * 64}  olk_#{version}_darwin_arm64.tar.gz extra\n" => /malformed checksum line/,
      "#{'z' * 64}  olk_#{version}_darwin_arm64.tar.gz\n#{'2' * 64}  olk_#{version}_darwin_amd64.tar.gz\n" =>
        /invalid SHA-256 for olk_#{Regexp.escape(version)}_darwin_arm64/,
    }.each do |contents, message|
      path = File.join(@dir, "bad-checksums.txt")
      File.write(path, contents)
      _, err, status = run_script(tag, checksums: path)
      refute status.success?, contents
      assert_match message, err
    end
  end

  def test_refuses_an_unattended_downgrade_but_allows_a_named_rollback
    assert run_script("v1.14.1-alpha.2")[2].success?

    _, err, status = run_script("v1.14.1-alpha.1")
    refute status.success?
    assert_match(/refusing to move olk from 1\.14\.1-alpha\.2 down/, err)

    _, err, status = run_script("v1.14.1-alpha.1", env: { "ALLOW_DOWNGRADE" => "true" })
    assert status.success?, err
    assert_match(/^  version "1\.14\.1-alpha\.1"$/, File.read(@cask))
  end

  def test_rerunning_the_same_release_changes_nothing
    assert run_script("v1.14.1-alpha.1")[2].success?
    before = File.read(@cask)
    assert run_script("v1.14.1-alpha.1")[2].success?
    assert_equal before, File.read(@cask)
  end
end
