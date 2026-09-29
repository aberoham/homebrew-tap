# frozen_string_literal: true

require "minitest/autorun"
require "open3"
require_relative "../scripts/teams_channel"

class TeamsChannelTest < Minitest::Test
  SCRIPT = File.expand_path("../scripts/teams_channel.rb", __dir__)

  # The fork publishes both channels, so each must ignore the other's
  # releases however recent, and pick by version, not by listing order.
  TAGS = %w[
    upstream-v0.9.0
    v0.9.1-alpha.2
    upstream-v0.10.0
    v0.9.1-alpha.10
    upstream-v0.8.0
    v0.9.1-beta.1
    v0.7.1-alpha.3
    v1.0.0
    upstream-v2.0.0-alpha.1
  ].freeze

  def test_newest_picks_the_highest_version_of_the_channel
    assert_equal "upstream-v0.10.0", TeamsChannel.newest("stable", TAGS)
    assert_equal "v0.9.1-beta.1", TeamsChannel.newest("next", TAGS)
    assert_nil TeamsChannel.newest("stable", %w[v0.8.1-alpha.1 v1.0.0])
  end

  def test_version_tags_and_formulae
    assert_equal "v0.8.0", TeamsChannel.version_tag("stable", "upstream-v0.8.0")
    assert_equal "v0.8.1-alpha.1", TeamsChannel.version_tag("next", "v0.8.1-alpha.1")
    assert_equal "teams-cli", TeamsChannel.formula("stable")
    assert_equal "teams-cli-next", TeamsChannel.formula("next")
    assert_raises(ArgumentError) { TeamsChannel.version_tag("stable", "v0.8.0") }
    assert_raises(ArgumentError) { TeamsChannel.version_tag("next", "upstream-v0.8.0") }
    assert_raises(ArgumentError) { TeamsChannel.formula("beta") }
  end

  # Every mirrored release is attested, including a rollback to an old one;
  # fork prereleases are attested from 0.8.1-alpha.1.
  def test_attestation_is_required_for_every_stable_release_and_recent_next_ones
    %w[upstream-v0.1.0 upstream-v0.8.0 upstream-v1.2.3].each do |tag|
      assert TeamsChannel.attested?("stable", tag), tag
    end
    %w[v0.8.1-alpha.1 v0.8.1-rc.1 v0.9.0-alpha.1].each do |tag|
      assert TeamsChannel.attested?("next", tag), tag
    end
    %w[v0.7.1-alpha.3 v0.8.0-rc.1].each do |tag|
      refute TeamsChannel.attested?("next", tag), tag
    end
  end

  def test_command_line
    out, _, status = Open3.capture3("ruby", SCRIPT, "newest", "next", stdin_data: TAGS.join("\n"))
    assert status.success?
    assert_equal "v0.9.1-beta.1\n", out
    out, = Open3.capture3("ruby", SCRIPT, "attested", "next", "v0.7.1-alpha.3")
    assert_equal "exempt\n", out
    out, = Open3.capture3("ruby", SCRIPT, "attested", "stable", "upstream-v0.8.0")
    assert_equal "required\n", out
    _, err, status = Open3.capture3("ruby", SCRIPT, "version-tag", "stable", "v0.8.0")
    refute status.success?
    assert_match(/expected upstream-vX\.Y\.Z/, err)
  end
end
