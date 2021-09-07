[![Build Status](https://app.travis-ci.com/g3ortega/price_calculator.svg?branch=main)][travis]
[![Coverage Status](https://img.shields.io/coveralls/g3ortega/price_calculator.svg)][coveralls]

[travis]: https://app.travis-ci.com/g3ortega/price_calculator
[coveralls]: https://coveralls.io/r/g3ortega/price_calculator

# PriceCalculator

Price Calculator is a CLI App to calculate prices for an inventory of products provided via a JSON file, eg:

```json
[
  {
    "name": "Bread",
    "unit_price": "2.17",
    "discount": {
      "quantity": 3,
      "price": "6.0"
    }
  },
  {
    "name": "Banana",
    "unit_price": "0.99"
  }
]
```

You can even provide a discount, and we're going to calculate everything for you from your awesome terminal 🚀


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'price_calculator'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install price_calculator

### OR

To install it locally.

```
  rake build
  rake install
```

## Usage

You need to provide an `inventory_file_path`, you can provide it using the flag `--inventory_file=path_to_inventory.json` or using an environment variable `INVENTORY_FILE_PATH`

To run it without install it. From project root path execute:

```
bundle exec exe/price_calculator order --inventory_file_path=./data/inventory.json
```

### Print current inventory

```
price_calculator pricing_table --inventory_file_path=./data/inventory.json

+--------+------------+------------+
|  Item  | Unit Price | Sale Price |
+--------+------------+------------+
| Milk   | $3.97      | 2 for $5.0 |
| Bread  | $2.17      | 3 for $6.0 |
| Banana | $0.99      |            |
| Apple  | $0.89      |            |
+--------+------------+------------+
```

### Start a new order

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

## TODO MVP
- [X] Use/enforce BigDecimal for prices
- [X] Add command to CLI that shows the current pricing table based on inventory
- [X] Enforcing type checking using dry-types. Impact> [POROs vs dry-type + dry-struct comparison](profiling/poros-vs-dry-type-structs.md)
- [X] Revisit naming (refactoring to make more sense to classes responsibility & structure)
- [X] Improve coverage
- [ ] Improve documentation
- [ ] Add utility module and extract some methods
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
