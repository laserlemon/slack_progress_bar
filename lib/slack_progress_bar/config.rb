# frozen_string_literal: true

class SlackProgressBar
  class Config
    InvalidConfigError = Class.new(StandardError)

    DEFAULT_PREFIX = "pb"

    # The default letters stand for: purple, blue, green, yellow, orange, red,
    # and white. See SlackProgressBar::Generator::DEFAULT_COLORS for more
    # information.
    DEFAULT_LETTERS = %w[p b g y o r w].freeze

    DEFAULT_ALIASES = {
      purple: "p",
      blue: "b",
      green: "g",
      yellow: "y",
      orange: "o",
      red: "r",
      white: "w",
    }.freeze

    PREFIX_PATTERN = /\A[0-9a-z]+\z/.freeze
    LETTER_PATTERN = /\A[a-z]\z/.freeze

    SEPARATOR = "-"
    LEFT_CAP_SUFFIX = "a"
    RIGHT_CAP_SUFFIX = "z"
    CIRCLE_SUFFIX = "o"

    attr_accessor :prefix, :letters, :aliases

    def initialize
      @prefix = DEFAULT_PREFIX
      @letters = DEFAULT_LETTERS
      @aliases = DEFAULT_ALIASES
    end

    def validate!
      unless prefix.is_a?(String)
        raise InvalidConfigError, "The prefix must be a String. Found #{prefix.class.name}: #{prefix.inspect}"
      end

      unless PREFIX_PATTERN.match?(prefix)
        raise InvalidConfigError, "The prefix must only contain digits 0-9 and/or lowercase letters a-z. Found: #{prefix.inspect}"
      end

      unless letters.is_a?(Array)
        raise InvalidConfigError, "Configured letters must be an Array. Found #{letters.class.name}: #{letters.inspect}"
      end

      case letters.size
      when 0
        raise InvalidConfigError, "Provide at least two letters."
      when 1
        raise InvalidConfigError, "Provide at least two letters. The last letter will be used as the default."
      end

      unless letters.uniq.size == letters.size
        raise InvalidConfigError, "Configured letters must be unique."
      end

      letters.each do |letter|
        unless letter.is_a?(String)
          raise InvalidConfigError, "Every letter must be a String. Found #{letter.class.name}: #{letter.inspect}"
        end

        unless LETTER_PATTERN.match?(letter)
          raise InvalidConfigError, "The only valid letters are lowercase a-z. Found: #{letter.inspect}"
        end
      end

      unless aliases.is_a?(Hash)
        raise InvalidConfigError, "Configured aliases must be a Hash. Found #{aliases.class.name}: #{aliases.inspect}"
      end

      aliases.each do |name, letter|
        unless name.is_a?(Symbol)
          raise InvalidConfigError, "Every alias must have a Symbol name. Found #{name.class.name}: #{name.inspect}"
        end

        unless letter.is_a?(String)
          raise InvalidConfigError, "Every alias must point to a String letter. Found #{letter.class.name}: #{letter.inspect}"
        end

        unless letters.include?(letter)
          raise InvalidConfigError, "Every alias must point to a valid letter. Found: #{letter.inspect}"
        end
      end
    end

    def valid?
      validate!
    rescue InvalidConfigError
      false
    else
      true
    end

    def default_letter
      letters.last
    end

    def separator
      SEPARATOR
    end

    def left_cap_suffix
      LEFT_CAP_SUFFIX
    end

    def right_cap_suffix
      RIGHT_CAP_SUFFIX
    end

    def circle_suffix
      CIRCLE_SUFFIX
    end
  end
end
