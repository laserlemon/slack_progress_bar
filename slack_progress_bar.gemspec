# frozen_string_literal: true

require_relative "lib/slack_progress_bar/version"

Gem::Specification.new do |spec|
  spec.name    = "slack_progress_bar"
  spec.version = SlackProgressBar::VERSION
  spec.summary = "Generate beautiful progress bars using custom Slack emoji"

  spec.author  = "Steve Richert"
  spec.email   = "steve.richert@gmail.com"
  spec.license = "MIT"

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").grep_v(/\A(bin|spec|Rakefile)/)
  end

  spec.add_runtime_dependency "thor", "~> 1.0"

  spec.add_development_dependency "bundler", ">= 2"
  spec.add_development_dependency "rake", ">= 12"

  spec.required_ruby_version = ">= 2.6.0"

  spec.bindir = "exe"
  spec.executables = ["slack_progress_bar"]
end
