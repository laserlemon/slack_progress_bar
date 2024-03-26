# frozen_string_literal: true

require_relative "lib/slack_progress_bar/version"

Gem::Specification.new do |spec|
  spec.name    = "slack_progress_bar"
  spec.summary = "Generate beautiful progress bars using custom Slack emoji"
  spec.version = SlackProgressBar::VERSION

  spec.author   = "Steve Richert"
  spec.email    = "steve.richert@hey.com"
  spec.license  = "MIT"
  spec.homepage = "https://github.com/laserlemon/slack_progress_bar"

  spec.metadata = {
    "rubygems_mfa_required" => "true",
    "source_code_uri" => "https://github.com/laserlemon/slack_progress_bar",
    "homepage_uri" => "https://github.com/laserlemon/slack_progress_bar",
    "bug_tracker_uri" => "https://github.com/laserlemon/slack_progress_bar/issues",
    "funding_uri" => "https://github.com/sponsors/laserlemon",
  }

  spec.required_ruby_version = ">= 3.0.0"
  spec.add_runtime_dependency "thor", "~> 1.0"
  spec.add_development_dependency "bundler", ">= 2"
  spec.add_development_dependency "rake", ">= 13"

  spec.files = [
    "exe/slack_progress_bar",
    "lib/slack_progress_bar.rb",
    "lib/slack_progress_bar/cli.rb",
    "lib/slack_progress_bar/config.rb",
    "lib/slack_progress_bar/generator.rb",
    "lib/slack_progress_bar/version.rb",
    "LICENSE.txt",
  ]

  spec.bindir = "exe"
  spec.executables = ["slack_progress_bar"]
  spec.extra_rdoc_files = ["README.md"]
end
