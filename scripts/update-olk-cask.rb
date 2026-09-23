#!/usr/bin/env ruby
# frozen_string_literal: true

# Writes Casks/olk.rb for one fork prerelease of olk. Set ALLOW_DOWNGRADE=true
# to move the cask to a lower version, as a deliberate rollback does.

tag, repository, checksums_path, cask_path = ARGV

unless ARGV.length == 4
  abort "usage: update-olk-cask.rb TAG REPOSITORY CHECKSUMS CASK"
end

# The fork channel carries prereleases only, so it can never shadow an
# upstream stable release of the same number. Limiting the labels to alpha,
# beta and rc keeps RubyGems' ordering, used below, identical to Homebrew's.
unless tag.match?(/\Av\d+\.\d+\.\d+-(?:alpha|beta|rc)\.\d+\z/)
  abort "invalid release tag: #{tag.inspect} (expected vX.Y.Z-alpha.N, -beta.N or -rc.N)"
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

version = tag.delete_prefix("v")
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
    abort "refusing to move olk from #{current_version} down to #{version} " \
          "without ALLOW_DOWNGRADE=true"
  end
end

download = "https://github.com/#{repository}/releases/download/v\#{version}/olk_\#{version}"

# The archive holds olk at its root. The binary is not notarized, so a
# postflight step removes the quarantine flag that would otherwise make
# Gatekeeper kill it on first run. Declarative `postflight_steps` replace the
# deprecated Ruby `postflight` block; Homebrew has supported them since 6.0.15.
cask = <<~RUBY
  cask "olk" do
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
    desc "CLI for Microsoft Outlook via Microsoft Graph API"
    homepage "https://github.com/#{repository}"

    livecheck do
      skip "Updated by this tap's update-olk-cask workflow"
    end

    binary "olk"

    postflight_steps do
      run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{staged_path}}/olk"]
    end
  end
RUBY

File.write(cask_path, cask) unless File.exist?(cask_path) && File.read(cask_path) == cask
