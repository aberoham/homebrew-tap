#!/usr/bin/env ruby
# frozen_string_literal: true

require "open3"
require_relative "macos-release-policy"

module VerifyMacOSRelease
  def self.run!(product, tag, binary, runner: Open3.method(:capture3))
    unless MacOSReleasePolicy.signed?(product, tag)
      puts "Legacy release #{tag}: signature gate does not apply (rollback compatibility)."
      return
    end

    identifier = MacOSReleasePolicy::CUTOVERS.fetch(product).last
    # Validate a Developer ID chain as well as the claimed Team ID and identifier.
    # A leading "=" makes codesign read the argument as requirement text; without
    # it, -R names a requirement file and every verification fails.
    requirement = %(=anchor apple generic and identifier "#{identifier}" and ) +
                  %(certificate leaf[subject.OU] = "2VLHJGU477" and ) +
                  "certificate 1[field.1.2.840.113635.100.6.2.6] exists and " +
                  "certificate leaf[field.1.2.840.113635.100.6.1.13] exists"
    commands = [
      ["/usr/bin/codesign", "--verify", "--strict", "--verbose=2", "-R", requirement, binary],
      ["/usr/bin/codesign", "-dvvv", binary],
    ]
    if product == "olk"
      # codesign's online ticket check supports a bare Mach-O executable.
      # syspolicy_check distribution is for apps; spctl --type install is for packages.
      commands << ["/usr/bin/codesign", "--verify", "--strict", "--check-notarization", binary]
    end
    commands.each_with_index do |command, index|
      out, err, status = runner.call(*command)
      raise "#{command.first} failed: #{err}" unless status.success?

      if index == 1
        details = out + err
        expected = ["TeamIdentifier=2VLHJGU477", "Identifier=#{identifier}"]
        raise "Unexpected signing identity" unless expected.all? { |line| details.lines.map(&:chomp).include?(line) }
      end
    end
    puts "Verified #{product} #{tag}: Developer ID identity#{product == 'olk' ? ' and notarization ticket' : ''}."
  end
end

if $PROGRAM_NAME == __FILE__
  abort "usage: verify-macos-release.rb PRODUCT TAG BINARY" unless ARGV.length == 3
  VerifyMacOSRelease.run!(*ARGV)
end
