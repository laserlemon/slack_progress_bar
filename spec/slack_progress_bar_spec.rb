# frozen_string_literal: true

RSpec.describe SlackProgressBar do
  it "has a version number" do
    expect(SlackProgressBar::VERSION).not_to be_nil
  end

  it "shows an empty progress bar" do
    bar = described_class.new

    expect(bar.to_s).to eq(":pb-w-a::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-w-z:")
  end

  it "shows a full progress bar" do
    bar = described_class.new(counts: { green: 1 })

    expect(bar.to_s).to eq(":pb-g-a::pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-g-z:")
  end

  it "shows singular progress" do
    bar = described_class.new(counts: { green: 1 }, total: 2)

    expect(bar.to_s).to eq(":pb-g-a::pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-w-z:")
  end

  it "shows multiple progress" do
    bar = described_class.new(counts: { blue: 1, green: 2 }, total: 5)

    expect(bar.to_s).to eq(":pb-b-a::pb-bbbb::pb-bbbb::pb-bggg::pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-gwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-w-z:")
  end

  it "shows a squared, empty progress bar" do
    bar = described_class.new(rounded: false)

    expect(bar.to_s).to eq(":pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww:")
  end

  it "shows a squared, full progress bar" do
    bar = described_class.new(counts: { green: 1 }, rounded: false)

    expect(bar.to_s).to eq(":pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-gggg:")
  end

  it "shows singular progress in a squared progress bar" do
    bar = described_class.new(counts: { green: 1 }, total: 2, rounded: false)

    expect(bar.to_s).to eq(":pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww:")
  end

  it "shows multiple progress in a squared progress bar" do
    bar = described_class.new(counts: { blue: 1, green: 1 }, total: 5, rounded: false)

    expect(bar.to_s).to eq(":pb-bbbb::pb-bbbb::pb-bbbg::pb-gggg::pb-gggg::pb-ggww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww:")
  end

  it "handles overflow gracefully" do
    bar = described_class.new(counts: { blue: 3, green: 3 }, total: 5)

    expect(bar.to_s).to eq(":pb-b-a::pb-bbbb::pb-bbbb::pb-bbbb::pb-bbbb::pb-bbbb::pb-bbbb::pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-g-z:")
  end

  it "ignores unknown aliases" do
    bar = described_class.new(counts: { unknown: 1 }, total: 2)

    expect(bar.to_s).to eq(":pb-w-a::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-w-z:")
  end

  it "shows progress by letter" do
    bar = described_class.new(counts: { "b" => 1, "g" => 2 }, total: 5)

    expect(bar.to_s).to eq(":pb-b-a::pb-bbbb::pb-bbbb::pb-bggg::pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-gwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-w-z:")
  end

  it "ignores unknown letters" do
    bar = described_class.new(counts: { "u" => 1 }, total: 2)

    expect(bar.to_s).to eq(":pb-w-a::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-w-z:")
  end

  it "combines counts for the same color" do
    bar = described_class.new(counts: { green: 1, "g" => 1 }, total: 4)

    expect(bar.to_s).to eq(":pb-g-a::pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-w-z:")
  end

  it "shows a custom sized progress bar" do
    bar = described_class.new(counts: { green: 1 }, total: 2, size: 4)

    expect(bar.to_s).to eq(":pb-g-a::pb-gggg::pb-wwww::pb-w-z:")
  end
end
