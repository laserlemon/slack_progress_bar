# frozen_string_literal: true

class SlackProgressBar
  class Config
    InvalidConfigError = Class.new(StandardError)

    DEFAULT_PREFIX = "pb"

    # The default letters stand for: purple, blue, green, yellow, orange, red,
    # and white. See SlackProgressBar::Generator::DEFAULT_COLORS for more
    # information.
    DEFAULT_LETTERS = %w[ p b g y o r w ].freeze

    PREFIX_PATTERN = %r{\A[0-9a-z]+\z}
    LETTER_PATTERN = %r{\A[a-z]\z}

    SEPARATOR = "-"

    attr_accessor :prefix, :letters

    def initialize
      @prefix = DEFAULT_PREFIX
      @letters = DEFAULT_LETTERS
    end

    def validate!
      unless prefix.is_a?(String)
        raise InvalidConfigError, "The prefix must be a String. Found: #{prefix.class.name}"
      end

      unless PREFIX_PATTERN.match?(prefix)
        raise InvalidConfigError, "The prefix must only contain digits 0-9 and/or lowercase letters a-z. Found: #{prefix.inspect}"
      end

      unless letters.is_a?(Array)
        raise InvalidConfigError, "Configured letters must be an Array. Found: #{letter.class.name}"
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
        unless LETTER_PATTERN.match?(letter)
          raise InvalidConfigError, "The only valid letters are lowercase a-z. Found: #{letter.inspect}"
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
  end
end
