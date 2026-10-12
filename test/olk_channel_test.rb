# frozen_string_literal: true

require "minitest/autorun"
require "open3"
require_relative "../scripts/olk_channel"

class OlkChannelTest < Minitest::Test
  SCRIPT = File.expand_path("../scripts/olk_channel.rb", __dir__)

  # The fork publishes both channels, so each must ignore the other's
  # releases however recent, and pick by version, not by listing order.
  TAGS = %w[
    upstream-v1.16.1
    v1.15.2-alpha.2
    upstream-v1.9.6
    v1.16.2-alpha.10
    v1.16.2-alpha.2
    upstream-v1.10.0
    v1.16.2-beta.1
    v2.0.0
    upstream-v2.0.0-alpha.1
  ].freeze

  def test_newest_picks_the_highest_version_of_the_channel
    assert_equal "upstream-v1.16.1", OlkChannel.newest("stable", TAGS)
    assert_equal "v1.16.2-beta.1", OlkChannel.newest("next", TAGS)
    assert_nil OlkChannel.newest("stable", %w[v1.15.2-alpha.2 v2.0.0])
  end

  def test_version_tags_and_casks
    assert_equal "v1.16.1", OlkChannel.version_tag("stable", "upstream-v1.16.1")
    assert_equal "v1.16.2-alpha.1", OlkChannel.version_tag("next", "v1.16.2-alpha.1")
    assert_equal "olk", OlkChannel.cask("stable")
    assert_equal "olk-next", OlkChannel.cask("next")
    assert_equal "olk-next", OlkChannel.other_cask("stable")
    assert_raises(ArgumentError) { OlkChannel.version_tag("stable", "v1.16.1") }
    assert_raises(ArgumentError) { OlkChannel.version_tag("next", "upstream-v1.16.1") }
    assert_raises(ArgumentError) { OlkChannel.cask("beta") }
  end

  # Every mirrored release is attested; fork prereleases from 1.16.2-alpha.1.
  def test_attestation_is_required_for_every_stable_release_and_recent_next_ones
    %w[upstream-v1.9.6 upstream-v1.16.1].each do |tag|
      assert OlkChannel.attested?("stable", tag), tag
    end
    %w[v1.16.2-alpha.1 v1.16.2-rc.1 v1.17.0-alpha.1].each do |tag|
      assert OlkChannel.attested?("next", tag), tag
    end
    %w[v1.15.2-alpha.2 v1.14.1-alpha.2].each do |tag|
      refute OlkChannel.attested?("next", tag), tag
    end
  end

  def test_command_line
    out, _, status = Open3.capture3("ruby", SCRIPT, "newest", "next", stdin_data: TAGS.join("\n"))
    assert status.success?
    assert_equal "v1.16.2-beta.1\n", out
    out, = Open3.capture3("ruby", SCRIPT, "attested", "next", "v1.15.2-alpha.2")
    assert_equal "exempt\n", out
    out, = Open3.capture3("ruby", SCRIPT, "attested", "stable", "upstream-v1.16.1")
    assert_equal "required\n", out
    _, err, status = Open3.capture3("ruby", SCRIPT, "version-tag", "stable", "v1.16.1")
    refute status.success?
    assert_match(/expected upstream-vX\.Y\.Z/, err)
  end
end
