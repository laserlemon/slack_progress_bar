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
    option :output,
      type: :string,
      default: defaults.output

    def generate
      generator = Generator.new(
        colors: options[:colors],
        prefix: options[:prefix],
        output: options[:output],
      )

      generator.generate
    end
  end
end
