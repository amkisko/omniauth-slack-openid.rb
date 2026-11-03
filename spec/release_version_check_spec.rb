# frozen_string_literal: true

require "spec_helper"
require "tmpdir"
require_relative "../usr/lib/release_version_check"

RSpec.describe ReleaseVersionCheck do
  describe ".confirmation_accepted?" do
    it "accepts an explicit yes or an interactive default" do
      expect(described_class.confirmation_accepted?("y\n")).to be(true)
      expect(described_class.confirmation_accepted?("Y\n")).to be(true)
      expect(described_class.confirmation_accepted?("\n")).to be(true)
    end

    it "rejects EOF and other answers" do
      expect(described_class.confirmation_accepted?(nil)).to be(false)
      expect(described_class.confirmation_accepted?("n\n")).to be(false)
    end
  end

  describe ".changelog_includes_version?" do
    it "accepts plain and Keep a Changelog headings" do
      Dir.mktmpdir do |dir|
        path = File.join(dir, "CHANGELOG.md")
        File.write(path, <<~MD)
          # CHANGELOG
          ## 2.0.2 (2026-11-03)
          ## [1.2.3] - 2026-01-01
          ## 9.9.9 (Unreleased)
        MD

        expect(described_class.changelog_includes_version?("2.0.2", path: path)).to be(true)
        expect(described_class.changelog_includes_version?("1.2.3", path: path)).to be(true)
        expect(described_class.changelog_includes_version?("9.9.9", path: path)).to be(false)
        expect(described_class.changelog_includes_version?("0.0.1", path: path)).to be(false)
      end
    end
  end

  describe ".require_changelog_version!" do
    it "aborts when the changelog heading is missing" do
      Dir.mktmpdir do |dir|
        path = File.join(dir, "CHANGELOG.md")
        File.write(path, "# CHANGELOG\n## 1.0.0\n")

        expect {
          expect {
            described_class.require_changelog_version!(version: "2.0.2", path: path)
          }.to output(/release requires/).to_stderr
        }.to raise_error(SystemExit)
      end
    end

    it "passes when the changelog heading is present" do
      Dir.mktmpdir do |dir|
        path = File.join(dir, "CHANGELOG.md")
        File.write(path, "# CHANGELOG\n## 2.0.2 (2026-11-03)\n")

        expect {
          described_class.require_changelog_version!(version: "2.0.2", path: path)
        }.not_to raise_error
      end
    end
  end
end
