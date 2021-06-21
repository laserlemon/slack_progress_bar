# frozen_string_literal: true

require "slack_progress_bar"

require "open3"
require "rqrcode"

class SlackProgressBar
  class Generator
    Error = Class.new(StandardError)
    CommandFailedError = Class.new(Error)
    ImageMagickError = Class.new(Error)
    ImageMagickMissingError = Class.new(ImageMagickError)
    ImageMagickOutdatedError = Class.new(ImageMagickError)
    OutputError = Class.new(Error)
    OutputMissingError = Class.new(OutputError)
    OutputNotWritableError = Class.new(OutputError)

    # The order in which these colors are configured is important; they will
    # appear in the same order in a rendered progress bar.
    #
    # The default colors below were borrowed from GitHub's Primer color system.
    # See: https://primer.style/css/support/color-system
    #
    # Each color consists of a six hex digits describing the RGB color and two
    # additional hex digits to describe the color's transparency. "00" is fully
    # transparent and "ff" is fully opaque.
    DEFAULT_COLORS = {
      "p" => "6f42c1ff", # purple
      "b" => "0366d6ff", # blue
      "g" => "28a745ff", # green
      "y" => "ffd33dff", # yellow
      "o" => "f66a0aff", # orange
      "r" => "d73a49ff", # red
      "w" => "959da544", # white
    }.freeze

    DEFAULT_OUTPUT = "./"

    IMAGE_MAGICK_VERSION_PATTERN = /Version: ImageMagick (?<major_version>\d+)\.[^\s]+/.freeze
    MINIMUM_IMAGE_MAGICK_MAJOR_VERSION = 6

    attr_reader :colors, :prefix, :output

    def initialize(colors: DEFAULT_COLORS, prefix: config.prefix, output: DEFAULT_OUTPUT)
      @colors = colors
      @prefix = prefix
      @output = output
    end

    def config
      @config ||= SlackProgressBar.config
    end

    def generate
      check_image_magick!
      check_output!

      generate_left_caps
      generate_right_caps
      generate_circles
      generate_stripes
      generate_qr_code
    end

    private

    def run_command(command)
      output, status = Open3.capture2e(command)

      raise CommandError, output unless status.success?

      output
    end

    def image_output_path(name)
      File.join(output, "#{name}.png")
    end

    def check_image_magick!
      output = run_command("convert -version")
      major_version = output.slice(IMAGE_MAGICK_VERSION_PATTERN, :major_version).to_i

      if major_version < MINIMUM_IMAGE_MAGICK_MAJOR_VERSION
        raise ImageMagickOutdatedError, <<~ERR
          ImageMagick is out of date.

          Please upgrade to ImageMagick #{MINIMUM_IMAGE_MAGICK_MAJOR_VERSION} or later.
        ERR
      end

      true
    rescue CommandFailedError
      raise ImageMagickMissingError, <<~ERR
        ImageMagick's "convert" command was not found.

        Please be sure that ImageMagick is installed, the "convert" command is
        available, and your PATH is configured to find the "convert" command.
      ERR
    end

    def check_output!
      unless File.directory?(output)
        raise OutputMissingError,
          "Output directory #{output.inspect} was not found."
      end

      unless File.writable?(output)
        raise OutputNotWritableError,
          "Output directory #{output.inspect} is not writable."
      end

      true
    end

    def generate_left_caps
      puts "Generating left caps"

      colors.each do |letter, color|
        name = [prefix, letter, config.left_cap_suffix].join(config.separator)
        path = image_output_path(name)

        run_command(%(convert -size 128x128 canvas:transparent -fill "##{color}" -draw "translate 127.5,63.5 circle 0,0 0,39.5" #{path}))
        print "."
      end

      puts
    end

    def generate_right_caps
      puts "Generating right caps"

      colors.each do |letter, color|
        name = [prefix, letter, config.right_cap_suffix].join(config.separator)
        path = image_output_path(name)

        run_command(%(convert -size 128x128 canvas:transparent -fill "##{color}" -draw "translate 0,63.5 circle 0,0 0,39.5" #{path}))
        print "."
      end

      puts
    end

    def generate_circles
      puts "Generating circles"

      colors.each do |letter, color|
        name = [prefix, letter, config.circle_suffix].join(config.separator)
        path = image_output_path(name)

        run_command(%(convert -size 128x128 canvas:transparent -fill "##{color}" -draw "translate 63.5,63.5 circle 0,0 0,39.5" #{path}))
        print "."
      end

      puts
    end

    def generate_stripes
      puts "Generating stripes"

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
        print "."
      end

      puts
    end

    def generate_qr_code
      puts "Generating QR code"

      count = 1
      previous_count = 0
      configs = []

      colors.each do |letter, color|
        configs << "#{letter}:#{color}:#{count}"

        count_to_add = previous_count
        previous_count = count
        count += count_to_add
      end

      anchor = configs.join("+")
      url = "https://laserlemon.github.io/slack_progress_bar/##{anchor}"
      qr = RQRCode::QRCode.new(url, level: :l)

      name = "#{prefix}#{config.separator}qr"
      path = image_output_path(name)

      IO.binwrite(path, qr.as_png(border_modules: 0, size: 128))
      puts "."
    end
  end
end
