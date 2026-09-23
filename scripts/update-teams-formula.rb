#!/usr/bin/env ruby
# frozen_string_literal: true

# Points Formula/teams-cli.rb at one fork prerelease. Set ALLOW_DOWNGRADE=true
# to move the formula to a lower version, as a deliberate rollback does.

tag, repository, checksums_path, formula_path = ARGV

unless ARGV.length == 4
  abort "usage: update-teams-formula.rb TAG REPOSITORY CHECKSUMS FORMULA"
end

# The fork channel carries prereleases only, so it can never shadow an
# upstream stable release of the same number.
unless tag.match?(/\Av\d+\.\d+\.\d+-[0-9A-Za-z.-]+\z/)
  abort "invalid release tag: #{tag.inspect} (expected vX.Y.Z-prerelease)"
end

allowed_repos = %w[aberoham/ms-teams-cli]
unless allowed_repos.include?(repository)
  abort "unexpected release repository: #{repository.inspect} (allowed: #{allowed_repos.join(', ')})"
end

checksums = File.foreach(checksums_path).to_h do |line|
  digest, filename, extra = line.split
  abort "malformed checksum line: #{line.inspect}" if digest.nil? || filename.nil? || extra

  [filename, digest]
end

targets = %w[
  aarch64-apple-darwin
  x86_64-apple-darwin
  aarch64-unknown-linux-musl
  x86_64-unknown-linux-musl
]

formula = File.read(formula_path)
original_formula = formula.dup
release_version = tag.delete_prefix("v")

# The published version is the explicit version line, or failing that the one
# embedded in the first download URL, which is how the inherited formula is
# written.
current_version = formula[/^[ \t]*version "([^"]+)"$/, 1] ||
                  formula[%r{/releases/download/v([^/"]+)/}, 1]
if current_version && ENV["ALLOW_DOWNGRADE"] != "true" &&
   Gem::Version.new(release_version) < Gem::Version.new(current_version)
  abort "refusing to move teams-cli from #{current_version} down to #{release_version} " \
        "without ALLOW_DOWNGRADE=true"
end

# Pin the formula version explicitly so Homebrew never has to infer it from
# the asset URL. Prerelease tags such as v0.5.0-alpha.1 are exactly where
# URL inference becomes unreliable.
if formula.sub!(/^[ \t]*version "[^"]*"\n/, "  version \"#{release_version}\"\n").nil?
  unless formula.sub!(/^([ \t]*license "[^"]+"\n)/) { %(#{$1}  version "#{release_version}"\n) }
    abort "could not set version: no version line and no license anchor"
  end
end

targets.each do |target|
  asset = "teams-#{tag}-#{target}.tar.gz"
  digest = checksums.fetch(asset) { abort "missing checksum for #{asset}" }
  abort "invalid SHA-256 for #{asset}: #{digest.inspect}" unless digest.match?(/\A[0-9a-f]{64}\z/)

  # Any owner matches so that the inherited upstream URLs are replaced too.
  pattern = %r{^(\s*)url "https://github\.com/[^/]+/ms-teams-cli/releases/download/[^/"]+/teams-[^/"]+-#{Regexp.escape(target)}\.tar\.gz"\n\1sha256 "[0-9a-f]{64}"$}
  matches = formula.scan(pattern).length
  abort "expected one formula block for #{target}, found #{matches}" unless matches == 1

  formula.sub!(pattern) do
    indent = Regexp.last_match(1)
    url = "https://github.com/#{repository}/releases/download/#{tag}/#{asset}"
    %(#{indent}url "#{url}"\n#{indent}sha256 "#{digest}")
  end
end

File.write(formula_path, formula) unless formula == original_formula
