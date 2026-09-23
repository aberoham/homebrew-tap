#!/usr/bin/env ruby
# frozen_string_literal: true

# Points Formula/entra.rb at one release of aberoham/ms-entra-cli. Pass
# --allow-downgrade to move the formula to a lower version, as a deliberate
# rollback does.
#
# Run it with `brew ruby`, not plain `ruby`: versions are compared with
# Homebrew's own Version class, which is how `brew upgrade` will order them.
# RubyGems orders some prerelease labels differently. `brew` clears most of
# the environment, which is why the downgrade switch is an argument.

unless defined?(Version) && Version.method_defined?(:<=>)
  abort "run this script with `brew ruby`, which provides Homebrew's Version class"
end

allow_downgrade = !ARGV.delete("--allow-downgrade").nil?
tag, repository, checksums_path, formula_path = ARGV

unless ARGV.length == 4
  abort "usage: brew ruby -- update-entra-formula.rb [--allow-downgrade] TAG REPOSITORY CHECKSUMS FORMULA"
end

# Entra publishes stable releases, with optional alpha, beta and release
# candidate prereleases.
unless tag.match?(/\Av\d+\.\d+\.\d+(?:-(?:alpha|beta|rc)\.\d+)?\z/)
  abort "invalid release tag: #{tag.inspect} (expected vX.Y.Z or vX.Y.Z-alpha.N, -beta.N, -rc.N)"
end

allowed_repos = %w[aberoham/ms-entra-cli]
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

current_version = formula[/^[ \t]*version "([^"]+)"$/, 1]
abort "formula has no explicit version line" if current_version.nil?

if !allow_downgrade && Version.new(release_version) < Version.new(current_version)
  abort "refusing to move entra from #{current_version} down to #{release_version} " \
        "without --allow-downgrade"
end

formula.sub!(/^([ \t]*)version "[^"]*"$/) { %(#{Regexp.last_match(1)}version "#{release_version}") }

targets.each do |target|
  asset = "entra-#{tag}-#{target}.tar.gz"
  digest = checksums.fetch(asset) { abort "missing checksum for #{asset}" }
  abort "invalid SHA-256 for #{asset}: #{digest.inspect}" unless digest.match?(/\A[0-9a-f]{64}\z/)

  pattern = %r{^(\s*)url "https://github\.com/aberoham/ms-entra-cli/releases/download/[^/"]+/entra-[^/"]+-#{Regexp.escape(target)}\.tar\.gz"\n\1sha256 "[0-9a-f]{64}"$}
  matches = formula.scan(pattern).length
  abort "expected one formula block for #{target}, found #{matches}" unless matches == 1

  formula.sub!(pattern) do
    indent = Regexp.last_match(1)
    url = "https://github.com/#{repository}/releases/download/#{tag}/#{asset}"
    %(#{indent}url "#{url}"\n#{indent}sha256 "#{digest}")
  end
end

File.write(formula_path, formula) unless formula == original_formula
