# frozen_string_literal: true

require "minitest/autorun"
require_relative "../scripts/verify-macos-release"

class VerifyMacOSReleaseTest < Minitest::Test
  Status = Struct.new(:success?)

  def verify(product, tag, bad_command: nil, details: nil)
    @commands = []
    runner = lambda do |*command|
      @commands << command
      identity = MacOSReleasePolicy::CUTOVERS.fetch(product).last
      text = details || "Identifier=#{identity}\nTeamIdentifier=2VLHJGU477\n"
      ["", command.include?("-dvvv") ? text : "", Status.new(!command.include?(bad_command))]
    end
    VerifyMacOSRelease.run!(product, tag, "/tmp/example binary", runner: runner)
  end

  def test_legacy_rollbacks_do_not_run_codesign
    { "teams" => "v0.7.1-alpha.2", "entra" => "v0.1.0", "olk" => "v1.14.1-alpha.1" }.each do |product, tag|
      verify(product, tag)
      assert_empty @commands
    end
  end

  def test_cutovers_and_later_releases_require_identity
    MacOSReleasePolicy::CUTOVERS.each do |product, (version, _)|
      ["v#{version || '0.0.0-alpha.1'}", "v99.0.0"].each do |tag|
        verify(product, tag)
        assert @commands.first.include?("--strict")
        requirement = @commands.first[@commands.first.index("-R") + 1]
        assert requirement.start_with?("=anchor apple generic"), "codesign -R needs inline requirement text"
        assert @commands.any? { |cmd| cmd.include?("--check-notarization") }
      end
    end
  end

  def test_rejects_invalid_signature_and_missing_notarization_ticket
    assert_raises(RuntimeError) { verify("teams", "v0.7.1-alpha.3", bad_command: "--verify") }
    assert_raises(RuntimeError) { verify("olk", "v1.14.1-alpha.2", bad_command: "--check-notarization") }
    assert_raises(RuntimeError) { verify("entra", "v0.1.1", bad_command: "--check-notarization") }
    assert_raises(RuntimeError) { verify("purview", "v0.1.0-rc.1", bad_command: "--check-notarization") }
    assert_raises(RuntimeError) { verify("teams", "v0.7.1-alpha.3", bad_command: "--check-notarization") }
  end

  # Purview was signed from its first release, so no version skips the gate,
  # including prereleases that RubyGems orders below 0.0.0.
  def test_every_purview_release_requires_identity
    %w[v0.0.0-alpha.1 v0.0.0-rc.1 v0.0.0 v0.0.1 v0.1.0-alpha.1 v0.1.0].each do |tag|
      verify("purview", tag)
      assert @commands.any? { |cmd| cmd.include?("--check-notarization") }, tag
    end
  end

  def test_rejects_wrong_team_and_identifier
    ["Identifier=com.aberoham.olk\nTeamIdentifier=WRONG\n",
     "Identifier=wrong\nTeamIdentifier=2VLHJGU477\n"].each do |details|
      assert_raises(RuntimeError) { verify("olk", "v1.14.1-alpha.2", details: details) }
    end
  end

  def test_rejects_malformed_tags_instead_of_treating_them_as_legacy
    assert_raises(ArgumentError) { verify("olk", "v1.14.1-garbage.2") }
    assert_raises(ArgumentError) { verify("purview", "v0.1.0-preview.1") }
  end
end
