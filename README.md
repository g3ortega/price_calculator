[![Build Status](https://app.travis-ci.com/g3ortega/foursquare_next.svg?branch=main)](https://app.travis-ci.com/g3ortega/foursquare_next)

# PriceCalculator

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/price_calculator`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'price_calculator'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install price_calculator

## Usage

To install it locally.

```
  rake build
  rake install
```

To run without install it. From project root path execute

```
  bundle exec exe/price_calculator order --inventory_file_path=./data/inventory.json
```


To load inventory you can provide the file path through an environment variable `INVENTORY_FILE_PATH` or providing the path using the `inventory_file_path` flag.

```
  price_calculator order --inventory_file_path=./data/inventory.json

  Please enter all the items purchased separated by a comma: milk,milk,milk
  +------+----------+-------+
  | Item | Quantity | Price |
  +------+----------+-------+
  | Milk | 3        | $8.97 |
  +------+----------+-------+
  Total price: $8.97
  You saved: $2.94 today
```

## TODO
- [X] Use/enforce BigDecimal for prices
- [ ] Add command to CLI that shows the current pricing table based on inventory
- [ ] Enforce types for entities (maybe using dry-types?)
- [ ] Improve coverage
- [ ] Improve documentation
- [ ] Validate attributes/data from inventory JSON file
- [ ] Manage order status?
- [ ] Persist/Update existence of products?

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/price_calculator. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the PriceCalculator project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/price_calculator/blob/master/CODE_OF_CONDUCT.md).
