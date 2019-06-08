# frozen_string_literal: true

class SlackProgressBar
  class Config
    # The "colors" configuration is only used for the one-time process of
    # generating custom Slack emoji images. Images will only be generated for a
    # given color if the key exists in both the colors and letters
    # configurations.
    #
    # The hex values below were borrowed from GitHub's Primer color system.
    # See: https://primer.style/css/support/color-system
    DEFAULT_COLORS = {
      purple: "6f42c1",
      blue:   "0366d6",
      green:  "28a745",
      yellow: "ffd33d",
      orange: "f66a0a",
      red:    "d73a49",
      white:  "e1e4e8",
    }.freeze

    # Both the keys and the values of the "letters" configuration must be
    # unique. Each value must be a single character, a-z. These letters are used
    # any time a progress bar is displayed as well as when the custom Slack
    # emoji images are generated. Your letters configuration should match (or be
    # a subset of) what was used when generating the custom emoji images for
    # your Slack workspace.
    #
    # Order is important here. Colors in your progress bar will always appear in
    # the same order as your letters configuration.
    DEFAULT_LETTERS = {
      # purple: "p",
      blue:   "b",
      green:  "g",
      yellow: "y",
      # orange: "o",
      red:    "r",
      white:  "w",
    }.freeze

    DEFAULT_PREFIX    = "pb".freeze
    DEFAULT_SEPARATOR = "_".freeze

    attr_accessor :colors
    attr_accessor :letters
    attr_accessor :prefix
    attr_accessor :separator

    def initialize
      @colors    = DEFAULT_COLORS
      @letters   = DEFAULT_LETTERS
      @prefix    = DEFAULT_PREFIX
      @separator = DEFAULT_SEPARATOR
    end

    def default_letter
      @default_letter ||= letters.values.last
    end

    attr_writer :default_letter
  end
end
