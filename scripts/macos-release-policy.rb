# frozen_string_literal: true

# Inclusive cutovers. Earlier releases remain available for explicit rollbacks.
# A nil cutover means the product was signed from its first release, so every
# valid tag, prereleases of 0.0.0 included, must pass the gate.
module MacOSReleasePolicy
  CUTOVERS = {
    "teams" => ["0.7.1-alpha.3", "com.aberoham.teams-cli"],
    "entra" => ["0.1.1", "com.aberoham.entra"],
    "olk" => ["1.14.1-alpha.2", "com.aberoham.olk"],
    "purview" => [nil, "com.aberoham.purview"],
  }.freeze

  def self.signed?(product, tag)
    unless tag.match?(/\Av\d+\.\d+\.\d+(?:-(?:alpha|beta|rc)\.\d+)?\z/)
      raise ArgumentError, "invalid release tag: #{tag.inspect}"
    end
    cutover = CUTOVERS.fetch(product).first
    return true if cutover.nil?

    Gem::Version.new(tag.delete_prefix("v")) >= Gem::Version.new(cutover)
  end
end
