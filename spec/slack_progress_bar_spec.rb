# frozen_string_literal: true

RSpec.describe SlackProgressBar do
  it "has a version number" do
    expect(SlackProgressBar::VERSION).not_to be nil
  end

  it "shows an empty progress bar" do
    bar = SlackProgressBar.new

    expect(bar.to_s).to eq(":pb-w-a::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-w-z:")
  end

  it "shows a full progress bar" do
    bar = SlackProgressBar.new(counts: { "g" => 1 })

    expect(bar.to_s).to eq(":pb-g-a::pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-g-z:")
  end

  it "shows singular progress" do
    bar = SlackProgressBar.new(counts: { "g" => 1 }, total: 2)

    expect(bar.to_s).to eq(":pb-g-a::pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-w-z:")
  end

  it "shows multiple progress" do
    bar = SlackProgressBar.new(counts: { "b" => 1, "g" => 2 }, total: 5)

    expect(bar.to_s).to eq(":pb-b-a::pb-bbbb::pb-bbbb::pb-bggg::pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-gwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-w-z:")
  end

  it "shows a squared, empty progress bar" do
    bar = SlackProgressBar.new(rounded: false)

    expect(bar.to_s).to eq(":pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww:")
  end

  it "shows a squared, full progress bar" do
    bar = SlackProgressBar.new(counts: { "g" => 1 }, rounded: false)

    expect(bar.to_s).to eq(":pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-gggg:")
  end

  it "shows singular progress in a squared progress bar" do
    bar = SlackProgressBar.new(counts: { "g" => 1 }, total: 2, rounded: false)

    expect(bar.to_s).to eq(":pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww:")
  end

  it "shows multiple progress in a squared progress bar" do
    bar = SlackProgressBar.new(counts: { "b" => 1, "g" => 1 }, total: 5, rounded: false)

    expect(bar.to_s).to eq(":pb-bbbb::pb-bbbb::pb-bbbg::pb-gggg::pb-gggg::pb-ggww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww:")
  end

  it "handles overflow gracefully" do
    bar = SlackProgressBar.new(counts: { "b" => 3, "g" => 3 }, total: 5)

    expect(bar.to_s).to eq(":pb-b-a::pb-bbbb::pb-bbbb::pb-bbbb::pb-bbbb::pb-bbbb::pb-bbbb::pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-g-z:")
  end

  it "ignores unknown letters" do
    bar = SlackProgressBar.new(counts: { "q" => 1 }, total: 2)

    expect(bar.to_s).to eq(":pb-w-a::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-w-z:")
  end
end
