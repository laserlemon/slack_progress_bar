# frozen_string_literal: true

require "slack_progress_bar/generator"

require "tmpdir"

RSpec.describe SlackProgressBar::Generator do
  it "generates images using default options" do
    Dir.mktmpdir do |output|
      generator = described_class.new(output: output)

      expect {
        generator.generate
      }.to change {
        Dir.children(output).count
      }.from(0).to(232)
    end
  rescue SlackProgressBar::Generator::ImageMagickError => error
    skip error.message.gsub(/\s+/, " ").strip
  end
end
