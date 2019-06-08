lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "slack_progress_bar/version"

Gem::Specification.new do |spec|
  spec.name    = "slack_progress_bar"
  spec.version = SlackProgressBar::VERSION
  spec.summary = "Generate beautiful progress bars using custom Slack emoji"

  spec.author  = "Steve Richert"
  spec.email   = "steve.richert@gmail.com"
  spec.license = "MIT"

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").grep_v(/\A(bin|spec)/)
  end

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 12.0"
end
