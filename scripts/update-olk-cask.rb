#!/usr/bin/env ruby
# frozen_string_literal: true

# Writes one olk cask for one fork release of its channel; see olk_channel.rb
# for the two channels. Set ALLOW_DOWNGRADE=true to move the cask to a lower
# version, as a deliberate rollback does.

require_relative "macos-release-policy"
require_relative "olk_channel"

channel, tag, repository, checksums_path, cask_path = ARGV

unless ARGV.length == 5
  abort "usage: update-olk-cask.rb stable|next TAG REPOSITORY CHECKSUMS CASK"
end

# The archives are named after the version the binary reports: upstream's tag
# for a mirrored release, the release tag itself for a fork prerelease. A
# channel writes only its own cask, so one channel's release can never land in
# the other's.
begin
  version_tag = OlkChannel.version_tag(channel, tag)
  cask_name = OlkChannel.cask(channel)
rescue ArgumentError => e
  abort e.message
end
unless File.basename(cask_path, ".rb") == cask_name
  abort "the #{channel} channel writes #{cask_name}.rb, not #{File.basename(cask_path)}"
end

allowed_repos = %w[aberoham/olkcli]
unless allowed_repos.include?(repository)
  abort "unexpected release repository: #{repository.inspect} (allowed: #{allowed_repos.join(', ')})"
end

checksums = File.foreach(checksums_path).to_h do |line|
  digest, filename, extra = line.split
  abort "malformed checksum line: #{line.inspect}" if digest.nil? || filename.nil? || extra

  [filename, digest]
end

version = version_tag.delete_prefix("v")
digests = %w[arm64 amd64].to_h do |arch|
  asset = "olk_#{version}_darwin_#{arch}.tar.gz"
  digest = checksums.fetch(asset) { abort "missing checksum for #{asset}" }
  abort "invalid SHA-256 for #{asset}: #{digest.inspect}" unless digest.match?(/\A[0-9a-f]{64}\z/)

  [arch, digest]
end

if File.exist?(cask_path)
  current_version = File.read(cask_path)[/^\s*version "([^"]+)"$/, 1]
  if current_version && ENV["ALLOW_DOWNGRADE"] != "true" &&
     Gem::Version.new(version) < Gem::Version.new(current_version)
    abort "refusing to move #{cask_name} from #{current_version} down to #{version} " \
          "without ALLOW_DOWNGRADE=true"
  end
end

release = channel == "stable" ? "upstream-v\#{version}" : "v\#{version}"
download = "https://github.com/#{repository}/releases/download/#{release}/olk_\#{version}"
desc, homepage =
  if channel == "stable"
    ["CLI for Microsoft Outlook via Microsoft Graph API", "https://github.com/rlrghb/olkcli"]
  else
    ["CLI for Microsoft Outlook via Microsoft Graph API (fork prereleases)", "https://github.com/#{repository}"]
  end

# Preserve the legacy cask form for rollback. For cutover releases the hook
# below is removed, and both macOS test jobs must verify the notarization
# ticket before the publish job can commit the candidate.
cask = <<~RUBY
  cask "#{cask_name}" do
    version "#{version}"

    on_macos do
      on_arm do
        sha256 "#{digests.fetch('arm64')}"
        url "#{download}_darwin_arm64.tar.gz"
      end
      on_intel do
        sha256 "#{digests.fetch('amd64')}"
        url "#{download}_darwin_amd64.tar.gz"
      end
    end

    name "olk"
    desc "#{desc}"
    homepage "#{homepage}"

    livecheck do
      skip "Updated by this tap's olk-cask workflow"
    end

    conflicts_with cask: "#{OlkChannel.other_cask(channel)}"

    binary "olk"

    postflight_steps do
      run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{staged_path}}/olk"]
    end
  end
RUBY

if MacOSReleasePolicy.signed?("olk", version_tag)
  cask = cask.sub(/\n  postflight_steps do\n.*?\n  end\n/m, "")
end

File.write(cask_path, cask) unless File.exist?(cask_path) && File.read(cask_path) == cask
