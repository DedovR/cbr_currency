# CbrCurrency

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/cbr_currency`. To experiment with that code, run `bin/console` for an interactive prompt.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cbr_currency', github: 'DedovR/cbr_currency'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cbr_currency

## Usage

Convert to secified currency
```ruby
require 'cbr_currency'

cash = CbrCurrency::Cash.new(100)
cash.convert_to!('USD')
cash.currency_code # 'USD'
cash.amount        # 1.7543
```

Convert to list of secified currencies
```ruby
cash = CbrCurrency::Cash.new(100)
cash.converting_list(['EUR', 'DKK'])
```

Addition
```ruby
rub_cash = CbrCurrency::Cash.new(100, currency: 'RUB')
usd_cash = CbrCurrency::Cash.new(100, currency: 'USD')

sum = rub_cash + usd_cash
sum.currency_code # 'RUB'
sum.amount        # 5800.2
```

Subtraction
```ruby
rub_cash = CbrCurrency::Cash.new(100, currency: 'RUB')
usd_cash = CbrCurrency::Cash.new(100, currency: 'USD')

sub = rub_cash - usd_cash
sub.currency_code # 'RUB'
sub.amount        # -5600.2
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/DedovR/cbr_currency.
