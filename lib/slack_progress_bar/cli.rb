require "slack_progress_bar"
require "slack_progress_bar/generator"

require "thor"

class SlackProgressBar
  class CLI < Thor
    defaults = Generator.new

    desc "generate",
      "Generate Slack emoji images"
    option :colors,
      type: :hash,
      default: defaults.colors
    option :prefix,
      type: :string,
      default: defaults.prefix

    def generate
      generator = Generator.new(
        colors: options[:colors],
        prefix: options[:prefix],
      )

      generator.generate
    end
  end
end
