# frozen_string_literal: true

require "open3"

class SlackProgressBar
  class Generator
    Error = Class.new(StandardError)
    CommandFailedError = Class.new(Error)
    ImageMagickError = Class.new(Error)
    ImageMagickMissingError = Class.new(ImageMagickError)
    ImageMagickOutdatedError = Class.new(ImageMagickError)

    # The order in which these colors are configured is important; they will
    # appear in the same order in a rendered progress bar.
    #
    # The default colors below were borrowed from GitHub's Primer color system.
    # See: https://primer.style/css/support/color-system
    DEFAULT_COLORS = {
      "p" => "6f42c1", # purple
      "b" => "0366d6", # blue
      "g" => "28a745", # green
      "y" => "ffd33d", # yellow
      "o" => "f66a0a", # orange
      "r" => "d73a49", # red
      "w" => "e1e4e8", # white
    }.freeze

    DEFAULT_PREFIX = "pb".freeze

    IMAGE_MAGICK_VERSION_PATTERN = %r{Version: ImageMagick (?<major_version>\d+)\.[^\s]+}

    attr_reader :colors, :prefix, :config

    def initialize(colors: DEFAULT_COLORS, prefix: DEFAULT_PREFIX)
      @colors = colors
      @prefix = prefix
      @config = SlackProgressBar.config
    end

    def generate
      check_image_magick!

      generate_left_caps
      generate_right_caps
      generate_circles
      generate_stripes
    end

    private

    def run_command(command)
      output, status = Open3.capture2e(command)

      if status.success?
        output
      else
        raise CommandError, output
      end
    end

    def image_output_path(name)
      "#{name}.png"
    end

    def check_image_magick!
      output = run_command("convert --version")
      major_version = output.slice(IMAGE_MAGICK_VERSION_PATTERN, :major_version).to_i

      if major_version < 7
        raise ImageMagickOutdatedError, <<~ERR
          ImageMagick is out of date.

          Please upgrade to ImageMagick 7 or later.
          ERR
      end
    rescue CommandFailedError
      raise ImageMagickMissingError, <<~ERR
        ImageMagick's "convert" command was not found.

        Please be sure that ImageMagick is installed, the "convert" command is
        available, and your PATH is configured to find the "convert" command.
        ERR
    end

    def generate_left_caps
      colors.each do |letter, color|
        name = [prefix, letter, config.left_cap_suffix].join(config.separator)
        path = image_output_path(name)

        run_command(%(convert -size 128x128 canvas:transparent -fill "##{color}" -draw "translate 127.5,63.5 circle 0,0 0,39.5" #{path}))
      end
    end

    def generate_right_caps
      colors.each do |letter, color|
        name = [prefix, letter, config.right_cap_suffix].join(config.separator)
        path = image_output_path(name)

        run_command(%(convert -size 128x128 canvas:transparent -fill "##{color}" -draw "translate 0,63.5 circle 0,0 0,39.5" #{path}))
      end
    end

    def generate_circles
      colors.each do |letter, color|
        name = [prefix, letter, config.circle_suffix].join(config.separator)
        path = image_output_path(name)

        run_command(%(convert -size 128x128 canvas:transparent -fill "##{color}" -draw "translate 63.5,63.5 circle 0,0 0,39.5" #{path}))
      end
    end

    def generate_stripes
      colors.keys.repeated_combination(4).each do |four_letters|
        four_colors = four_letters.map { |letter| colors.fetch(letter) }

        command = +%(convert -size 128x128 canvas:transparent)

        four_colors.each_with_index do |color, i|
          x1 = i * 32
          x2 = x1 + 32
          command << %( -fill "##{color}" -draw "rectangle #{x1},24 #{x2},103")
        end

        name = four_letters.join.prepend(prefix, config.separator)
        path = image_output_path(name)
        command << %( #{path})

        run_command(command)
      end
    end
  end
end
