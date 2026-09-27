# frozen_string_literal: true

# Inclusive cutovers. Earlier releases remain available for explicit rollbacks.
module MacOSReleasePolicy
  CUTOVERS = {
    "teams" => ["0.7.1-alpha.3", "com.aberoham.teams-cli"],
    "entra" => ["0.1.1", "com.aberoham.entra"],
    "olk" => ["1.14.1-alpha.2", "com.aberoham.olk"],
  }.freeze

  def self.signed?(product, tag)
    unless tag.match?(/\Av\d+\.\d+\.\d+(?:-(?:alpha|beta|rc)\.\d+)?\z/)
      raise ArgumentError, "invalid release tag: #{tag.inspect}"
    end
    Gem::Version.new(tag.delete_prefix("v")) >= Gem::Version.new(CUTOVERS.fetch(product).first)
  end
end
