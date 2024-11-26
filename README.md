# Converted

Converted is a shoot-from-the-hip media asset conversion system. It aims to convert video, audio, images, and text into alternate formats without any additional configuration or modification needed. This is a one-size-fits-all approach and may not be appropriate if you desire specific outcomes for your converted file.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'converted'
```

And then execute:

```sh
bundle install
```
Or install it yourself as:
```sh
gem install converted
```

## Usage

### PNG

```rb
converter = Converted::PNG.new('/root/someuser/converted/test/test_assets/image/test_image.png')

converter.convert_to_jpg('/root/someuser/somefolder/image.jpg')
converter.convert_to_gif('/root/someuser/somefolder/image.gif')
converter.convert_to_webp('/root/someuser/somefolder/image.webp')
converter.convert_to_avif('/root/someuser/somefolder/image.avif')
converter.convert_to_bmp('/root/someuser/somefolder/image.bmp', with_transparency: false)
# preverse transparency, but reduce color range from 32-bit to 24-bit
converter.convert_to_bmp('/root/someuser/somefolder/image.bmp', with_transparency: true)
```

Note: You can use `irb` to test from terminal:
```sh
# For example, png conversion
irb -Ilib -r converted/png
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/curiousmarkingsco/converted. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/curiousmarkingsco/converted/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Converted project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/curiousmarkingsco/converted/blob/main/CODE_OF_CONDUCT.md).
