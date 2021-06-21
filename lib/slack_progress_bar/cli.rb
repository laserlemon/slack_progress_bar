# frozen_string_literal: true

require "slack_progress_bar/generator"

require "thor"

class SlackProgressBar
  class CLI < Thor
    defaults = Generator.new

    desc "generate",
      "Generate Slack emoji images"
    option :colors,
      desc: "A collection of key/value pairs where the keys are letters used for image file naming and the values are hex colors used for image generation",
      type: :hash,
      default: defaults.colors
    option :prefix,
      desc: "A string used as the prefix for every generated image file name",
      type: :string,
      default: defaults.prefix
    option :output,
      desc: "The directory where all generated image files will be saved",
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
