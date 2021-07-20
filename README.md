# Slack Progress Bar<br><img src="https://user-images.githubusercontent.com/34264/125970661-b3229a24-439c-43e5-9108-97f46a2c47a6.png" width="404" aria-hidden="true">

Create _beautiful_ progress bars for Slack using **emoji**!

Slack Progress Bar is a Ruby library capable of [generating a progress bar](https://github.com/laserlemon/slack_progress_bar/blob/main/README.md#generating-a-progress-bar) made with Slack emoji. The library can also [generate the emoji](https://github.com/laserlemon/slack_progress_bar/blob/main/README.md#generating-the-emoji) images that you'll need in your Slack workspace.

⭐ [Try it out!](https://laserlemon.github.io/slack_progress_bar)

## Installation

Add this line to your application's Gemfile:

```ruby
gem "slack_progress_bar"
```

And then execute:

```
$ bundle install
```

Or install it yourself as:

```
$ gem install slack_progress_bar
```

## Usage

### Configuration

The library uses default colors based on the [GitHub Primer color system](https://primer.style/css/support/color-system) that allow you to hit the ground running without any in-app configuration. 

| Alias | Letter | Hex value | Preview |
|:--- |:---:|:--- |:---:|
| `purple` | `p` | `6f42c1ff` | <img src="https://user-images.githubusercontent.com/34264/125973904-b82923e7-9457-4d47-9e38-70c36ab3f07f.png" width="20"> |
| `blue` | `b` | `0366d6ff` | <img src="https://user-images.githubusercontent.com/34264/125973900-f3faa84f-d7de-4102-b39e-6e5d12a443ed.png" width="20"> |
| `green` | `g` | `28a745ff` | <img src="https://user-images.githubusercontent.com/34264/125973902-74679045-0d94-4b41-81e4-56275207d97d.png" width="20"> |
| `yellow` | `y` | `ffd33dff` | <img src="https://user-images.githubusercontent.com/34264/125973907-2d615a1f-1016-40c6-9061-3f6243527869.png" width="20"> |
| `orange` | `o` | `f66a0aff` | <img src="https://user-images.githubusercontent.com/34264/125973903-25daa839-16b1-43e8-91a3-7f4a134aa341.png" width="20"> |
| `red` | `r` | `d73a49ff` | <img src="https://user-images.githubusercontent.com/34264/125973905-2708f63c-1783-4daf-af23-da115e2612c9.png" width="20"> |
| `white` | `w` | `959da544` | <img src="https://user-images.githubusercontent.com/34264/125973906-c2a9dcf2-f009-4aa7-b303-529b7a24aa0f.png" width="20"> |

You can configure color naming and sequence in a Rails initializer or any other Ruby configuration file:

```ruby
SlackProgressBar.configure do |config|
  # These one-character color names are used in emoji image filenames.
  # The last color configured here is the default and is used to fill the remainder of a progress bar.
  config.letters = ["r", "g", "b", "w"]
  
  # Define your own aliases that map to each letter above, useful when generating a progress bar.
  config.aliases = {
    red: "r",
    green: "g",
    blue: "b",
    white: "w",
    deleted: "r",
    created: "g",
    updated: "b",
  }
end
```

The default emoji prefix is `pb`. For example, one Slack emoji using the configuration above could be `:pb-rgbw:`. The separator is `-` and isn't configurable. You can customize the prefix to prevent naming collisions. 

```ruby
SlackProgressBar.configure do |config|
  # Name emoji like `bar-gggg`.
  config.prefix = "bar"
end
```

### Generating a progress bar

Slack Progress Bar's primary interface for generating a progress bar is the `SlackProgressBar.new` and `SlackProgressBar#.to_s` methods. Examples below will assume default configuration.

By default, Slack Progress Bar generates an empty progress bar with 14 emoji and rounded caps:

```ruby
bar = SlackProgressBar.new
puts bar.to_s
```

```
:pb-w-a::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-w-z:
```

<img src="https://user-images.githubusercontent.com/34264/125977880-a36c14e0-3d7c-4891-a94f-0b024e3433a1.png" width="404">

But most folks want to show some, well… progress!

```ruby
bar = SlackProgressBar.new(counts: { blue: 3, green: 2, red: 1 })
puts bar.to_s
```

```
:pb-b-a::pb-bbbb::pb-bbbb::pb-bbbb::pb-bbbb::pb-bbbb::pb-bbbb::pb-gggg::pb-gggg::pb-gggg::pb-gggg::pb-rrrr::pb-rrrr::pb-r-z:
```

<img src="https://user-images.githubusercontent.com/34264/125979277-f59e926c-2fc2-4192-9bc1-6e36b28b6f13.png" width="404">

And if you want to indicate that progress is not yet finished:

```ruby
# Equivalent to: SlackProgressBar.new(counts: { blue: 3, green: 2, red: 1, white: 4 })
bar = SlackProgressBar.new(counts: { blue: 3, green: 2, red: 1 }, total: 10)
puts bar.to_s
```

```
:pb-b-a::pb-bbbb::pb-bbbb::pb-bbbb::pb-bbgg::pb-gggg::pb-gggg::pb-rrrr::pb-rwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-w-z:
```

<img src="https://user-images.githubusercontent.com/34264/125979830-ccc02bba-a85c-4509-957b-3dd234500448.png" width="404">

You can also change the size (in emoji) of the progress bar from its default of 14:

```ruby
bar = SlackProgressBar.new(counts: { blue: 3, green: 2, red: 1 }, total: 10, size: 10)
puts bar.to_s
```

```
:pb-b-a::pb-bbbb::pb-bbbb::pb-bggg::pb-gggg::pb-rrrw::pb-wwww::pb-wwww::pb-wwww::pb-w-z:
```

<img src="https://user-images.githubusercontent.com/34264/125980287-0093d19f-0ed8-4558-9765-8d2cde706138.png" width="276">

Finally, you can choose to generate your progress bar with square caps:

```ruby
bar = SlackProgressBar.new(counts: { blue: 3, green: 2, red: 1 }, total: 10, size: 10, rounded: false)
puts bar.to_s
```

```
:pb-bbbb::pb-bbbb::pb-bbbb::pb-gggg::pb-gggg::pb-rrrr::pb-wwww::pb-wwww::pb-wwww::pb-wwww:
```

<img src="https://user-images.githubusercontent.com/34264/125980701-f9d8a08c-d19a-424d-9198-f18ecbbd0c8d.png" width="320">

### Generating the emoji

⭐ **tl;dr:** If you want to use the default 7-color configuration, you can [download all 232 emoji images](https://github.com/laserlemon/slack_progress_bar/files/6848864/images.zip) (120 KB ZIP).

The observent reader will notice that `SlackProgressBar#to_s` (above) only generates a string. For Slack to render your beautiful progress bar, you'll need to generate and upload beautiful Slack emoji images! The `slack_progress_bar` gem comes with a `slack_progress_bar` command line interface and we'll use the `slack_progress_bar generate` command to create all the images you'll need.

For the default configuration, run `slack_progress_bar generate` with no arguments. Images will be created in your current working directory.

```bash
slack_progress_bar generate
```

The default configuration generates 232 images, which need to be uploaded to your Slack workspace. As of this writing, there is no API available to automate this manual process! 😅

You can reduce the number of images required by reducing the number of colors in your configuration:

```bash
slack_progress_bar generate --colors r:d73a49ff g:28a745ff b:0366d6ff w:959da544
```

The command above, configured for four colors, will generate only 48 images. Use the table below to help determine how many colors you're willing to support:

| Colors | Images |
| ---:| ---:|
| 2 | 12 |
| 3 | 25 |
| 4 | 48 |
| 5 | 86 |
| 6 | 145 |
| 7 | 232 |
| 8 | 355 |

When generating your images, each color you configure contains eight hex digits. The first six are RGB and the last two are alpha transparency.

⭐ You can experiment with different colors and progress bar styles using the [Slack Progress Bar sandbox](https://laserlemon.github.io/slack_progress_bar).

## Questions

### How does it work?

Slack Progress Bar works in two steps. First it performs the one-time process of generating 128px square emoji images. Once those are uploaded to your Slack workspace, it references the names of those emoji to generate beautiful progress bars.

### What's the progress bar's granularity?

By default, exactly 2%. That's why the default rounded progress bar size is 14 emoji. Each cap represents a "stripe" and every interior emoji represents four more stripes, for a total of 50 stripes at 2% per stripe. Below is an exploded progress bar to illustrate how the images are combined:

```
:pb-p-a::pb-bbgg::pb-gyyy::pb-yooo::pb-oooo::pb-orrr::pb-rrrr::pb-rrrr::pb-rwww::pb-wwww::pb-wwww::pb-wwww::pb-wwww::pb-w-z:
```

<img src="https://user-images.githubusercontent.com/34264/125985441-823e4c2f-379e-49f6-860a-e3d104bd173a.png" width="32">&nbsp;
<img src="https://user-images.githubusercontent.com/34264/125985470-67828620-291f-412d-b573-308271dbee5b.png" width="32">&nbsp;
<img src="https://user-images.githubusercontent.com/34264/125985517-28bb320f-0a58-4477-89f8-4e40a80eee6f.png" width="32">&nbsp;
<img src="https://user-images.githubusercontent.com/34264/125985564-b383037d-a0e8-4612-86c8-a1d9c8699e3c.png" width="32">&nbsp;
<img src="https://user-images.githubusercontent.com/34264/125985587-67b4b120-2780-4b5f-be2b-8477c966b71a.png" width="32">&nbsp;
<img src="https://user-images.githubusercontent.com/34264/125985616-8a121079-1c3e-4870-9df0-396b11cfbb06.png" width="32">&nbsp;
<img src="https://user-images.githubusercontent.com/34264/125985657-7f778bf3-2483-402c-97ee-72bb226c20de.png" width="32">&nbsp;
<img src="https://user-images.githubusercontent.com/34264/125985657-7f778bf3-2483-402c-97ee-72bb226c20de.png" width="32">&nbsp;
<img src="https://user-images.githubusercontent.com/34264/125985681-00ebfc9b-1caf-409f-966e-d2471fbe78ff.png" width="32">&nbsp;
<img src="https://user-images.githubusercontent.com/34264/125985711-afbcff71-f933-4ad3-bc37-e73f5906403b.png" width="32">&nbsp;
<img src="https://user-images.githubusercontent.com/34264/125985711-afbcff71-f933-4ad3-bc37-e73f5906403b.png" width="32">&nbsp;
<img src="https://user-images.githubusercontent.com/34264/125985711-afbcff71-f933-4ad3-bc37-e73f5906403b.png" width="32">&nbsp;
<img src="https://user-images.githubusercontent.com/34264/125985711-afbcff71-f933-4ad3-bc37-e73f5906403b.png" width="32">&nbsp;
<img src="https://user-images.githubusercontent.com/34264/125985743-150c8a04-8a90-4cd0-9da3-8614ef17410f.png" width="32">&nbsp;

### Why not use narrow emoji?

When you use a narrow rectangular emoji in Slack, horizontal margins are added so that it takes up the same amount of space as a square emoji. The result is that you can't position multiple narrow emoji _right_ next to each other. That's why Slack Progress Bar uses perfectly square emoji throughout.

### Can I animate my progress bar?

Sure! Slack's API gives you the ability to [create](https://api.slack.com/messaging/sending) and [update](https://api.slack.com/messaging/modifying) messages. So after you create your initial message with a blank progress bar, you can update that message as frequently as you like with the latest and greatest version of your progress bar.

<img src="https://user-images.githubusercontent.com/34264/125991787-d8c49424-106f-40ea-bf58-985adced4b1b.gif" width="374">

### Can I change the color order?

Sadly, no. 😢 In an effort to reduce the number of images you need to generate and upload, the order in which colors appear is fixed. For Slack Progress Bar to generate 7-color, _order-flexible_ progress bars, it would need to generate 2,423 images rather than 232! 😱

### Does it have dark mode?

Sure, kind of! Setting alpha transparency for your color configuration gives you some control over how your progress bars look in light and dark surroundings. For example, the default "white" color is dimmed using alpha transparency. The effect is a progress bar that's beautiful any time of day _or_ night:

<img src="https://user-images.githubusercontent.com/34264/125987921-3d7ac606-1ad3-4ebc-bf45-123df9b16411.png" width="448"><br>
<img src="https://user-images.githubusercontent.com/34264/125987920-491636ad-55a7-4c63-a243-feff09c284e6.png" width="448">

### I have a different question!

Great! Please feel free to open an [issue](https://github.com/laserlemon/slack_progress_bar/issues/new) and I'll do my best to give you an answer. 💛

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/laserlemon/slack_progress_bar. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the SlackProgressBar project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/laserlemon/slack_progress_bar/blob/main/CODE_OF_CONDUCT.md).
