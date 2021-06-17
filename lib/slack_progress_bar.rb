# frozen_string_literal: true

require "slack_progress_bar/config"
require "slack_progress_bar/version"

class SlackProgressBar
  def self.config
    @config ||= Config.new
  end

  def self.configure
    yield config
    config.validate!
  end

  attr_reader :counts, :total, :size

  # Create a new progress bar.
  #
  # The "counts" argument is a hash of symbol keys and integer values. Only keys
  # present in SlackProgressBar.config.letters will be rendered in the resulting
  # progress bar. If not provided, it's assumed that no progress has been made.
  #
  # The "total" argument is optional, defaulting to the sum of all provided
  # counts. If a total is provided that is greater than the sum of the counts,
  # the last configured color will be used to fill in the remainder of the bar.
  #
  # The "size" argument specifies how many emoji will be used to render the
  # progress bar. The default is 14 because the default progress bar has rounded
  # ends that each represent only one stripe. The remaining 12 emoji each
  # represent four stripes, for a total of 50 stripes, making each stripe count
  # for 2% of the total. Any size may be given but each stripe may represent an
  # unusual, floating point percentage of the total.
  #
  # The "rounded" argument accepts a boolean for whether the progress bar should
  # have rounded ends. This is a matter of personal preference and will affect
  # the whitespace on either side of the progress bar since the rounded end
  # emoji images are mostly negative space.
  def initialize(counts: {}, total: counts.values.sum, size: 14, rounded: true)
    @counts = counts.slice(*config.letters)
    @total = total
    @size = size
    @rounded = rounded
  end

  def to_s
    emoji
  end

  private

  def config
    self.class.config
  end

  def rounded?
    @rounded
  end

  def emoji
    return @emoji if @emoji

    emoji = +""

    if rounded?
      emoji << emojify(letters.slice(0), suffix: "a")
      emoji << emojify(letters.slice(1, stripes - 2))
      emoji << emojify(letters.slice(-1), suffix: "z")
    else
      emoji << emojify(letters)
    end

    @emoji = emoji
  end

  def emojify(letters, suffix: nil)
    emoji = +""

    letters.scan(/[a-z]{1,4}/) do |group|
      emoji << group.
        prepend(config.prefix, config.separator).
        tap { |s| s.concat(config.separator, suffix) if suffix }.
        prepend(":").
        concat(":")
    end

    emoji
  end

  def letters
    return @letters if @letters

    letters = +""
    running_total = 0

    config.letters.each do |letter|
      next unless count = counts[letter]

      running_total += count
      running_stripes = (running_total.to_f / effective_total * stripes).floor
      letters = letters.ljust(running_stripes, letter)
    end

    @letters = letters.ljust(stripes, config.default_letter)
  end

  def effective_total
    @effective_total ||= [counts.values.sum, total, 1].max
  end

  def stripes
    @stripes ||= rounded? ? ((size - 2) * 4) + 2 : size * 4
  end
end
