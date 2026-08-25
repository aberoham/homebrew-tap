#!/usr/bin/env ruby
# frozen_string_literal: true

tag, repository, checksums_path, formula_path = ARGV

unless ARGV.length == 4
  abort "usage: update-teams-formula.rb TAG REPOSITORY CHECKSUMS FORMULA"
end

unless tag.match?(/\Av\d+\.\d+\.\d+(?:[-+][0-9A-Za-z.-]+)?\z/)
  abort "invalid release tag: #{tag.inspect}"
end

allowed_repos = %w[osodevops/ms-teams-cli aberoham/ms-teams-cli]
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

targets.each do |target|
  asset = "teams-#{tag}-#{target}.tar.gz"
  digest = checksums.fetch(asset) { abort "missing checksum for #{asset}" }
  abort "invalid SHA-256 for #{asset}: #{digest.inspect}" unless digest.match?(/\A[0-9a-f]{64}\z/)

  # Match any owner for ms-teams-cli to support both upstream and fork releases
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
