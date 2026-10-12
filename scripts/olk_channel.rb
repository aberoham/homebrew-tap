# frozen_string_literal: true

# The two olk channels, both published by the fork aberoham/olkcli:
#
#   stable  olk: upstream-vX.Y.Z, upstream's vX.Y.Z rebuilt by the fork from
#           upstream's commit, signed, notarized and attested.
#   next    olk-next: the fork's own vX.Y.Z-alpha.N, -beta.N and -rc.N.
#
# Limiting next to alpha, beta and rc keeps RubyGems' version ordering, used
# here, identical to Homebrew's; the two disagree on labels such as "pre".
module OlkChannel
  CHANNELS = {
    # Every mirrored release is attested.
    "stable" => {
      cask:          "olk",
      other:         "olk-next",
      pattern:       /\Aupstream-(v\d+\.\d+\.\d+)\z/,
      expected:      "upstream-vX.Y.Z",
      attested_from: "0.0.0",
    },
    # The fork's releases carry attestations from 1.16.2-alpha.1 on; older ones
    # stay installable for rollbacks.
    "next"   => {
      cask:          "olk-next",
      other:         "olk",
      pattern:       /\A(v\d+\.\d+\.\d+-(?:alpha|beta|rc)\.\d+)\z/,
      expected:      "vX.Y.Z-alpha.N, -beta.N or -rc.N",
      attested_from: "1.16.2-alpha.1",
    },
  }.freeze

  def self.config(channel)
    CHANNELS.fetch(channel) do
      raise ArgumentError, "unknown channel: #{channel.inspect} (expected stable or next)"
    end
  end

  def self.cask(channel)
    config(channel)[:cask]
  end

  def self.other_cask(channel)
    config(channel)[:other]
  end

  # The version tag the archives are named after and the binary reports:
  # upstream's for a mirrored release, the release tag itself for next.
  def self.version_tag(channel, tag)
    match = config(channel)[:pattern].match(tag)
    raise ArgumentError, "invalid release tag: #{tag.inspect} (expected #{config(channel)[:expected]})" unless match

    match[1]
  end

  def self.version(channel, tag)
    Gem::Version.new(version_tag(channel, tag).delete_prefix("v"))
  end

  # The highest version among the channel's tags, ignoring every other tag.
  def self.newest(channel, tags)
    tags.grep(config(channel)[:pattern])
        .max_by { |tag| version(channel, tag) }
  end

  def self.attested?(channel, tag)
    version(channel, tag) >= Gem::Version.new(config(channel)[:attested_from])
  end
end

# Command-line use from the workflow:
#   olk_channel.rb newest CHANNEL < tags       prints the tag, or nothing
#   olk_channel.rb version-tag CHANNEL TAG     prints vX.Y.Z[-pre.N]
#   olk_channel.rb attested CHANNEL TAG        prints required or exempt
#   olk_channel.rb cask CHANNEL                prints the cask name
if $PROGRAM_NAME == __FILE__
  command, channel, tag = ARGV
  begin
    case command
    when "newest" then (newest = OlkChannel.newest(channel, $stdin.each_line.map(&:strip))) && puts(newest)
    when "version-tag" then puts OlkChannel.version_tag(channel, tag)
    when "attested" then puts(OlkChannel.attested?(channel, tag) ? "required" : "exempt")
    when "cask" then puts OlkChannel.cask(channel)
    else abort "usage: olk_channel.rb newest|version-tag|attested|cask CHANNEL [TAG]"
    end
  rescue ArgumentError => e
    abort e.message
  end
end
