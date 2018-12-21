[![CircleCI](https://circleci.com/gh/matass/business-period.svg?style=svg&circle-token=4f56e9b7fe1047d59c9f74d518b9bf377fa04bf8)](https://github.com/matass/business-period)
[![Maintainability](https://api.codeclimate.com/v1/badges/a98474a4f7a898b1abec/maintainability)](https://codeclimate.com/github/matass/business-period/maintainability)
[![Gem Version](https://badge.fury.io/rb/business-period.svg)](https://badge.fury.io/rb/business-period)
# Business period

**BusinessPeriod** is a ruby library that calculates business period by given hash.
This library was designed for lithuanian, latvian and estonian unemployment days.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'business-period'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install business-period

## Quickstart

There are two ways to initialize:

##### Initialization:

```ruby
# config/initializers/business_period.rb

# Set locale to get config file from config/holidays path.
# Set work_days to define which days of week are work days.

locale = 'lt'
work_days = [1, 2, 3, 4, 5]

BusinessPeriod::Config.locale = locale
BusinessPeriod::Config.work_days = work_days
```

##### Initialization with Proc:

```ruby
locale = 'lt'
work_days = [1, 2, 3, 4, 5]

BusinessPeriod::Config.locale = -> { locale }
BusinessPeriod::Config.work_days = -> { work_days }
```

## How it works

1. Dynamically calculates how many days we have to add to period end (Saturdays/Sundays/Holidays).
2. Generates new array.
2. Extracts weekends and holidays from newly generated array.
3. Generates result array.

## Usage

```ruby
# set period
period = { 2, 4 }

# You can pass optional parameters if You want to set primary day as starting point.
# period = { 2, 4, { primary_day: Time.now - (3600 * 24) } }

# Call BusinessPeriod::Days class to calculate period 
BusinessPeriod::Days.call(period)
```

## Examples
Let's say we have no holidays this month and today is Wednesday.

let `work_days = [1, 2, 3, 4, 5]` (all days except weekends)

let `period = { from_date: 2, to_date: 4 }`

* Begins to count period from the coming day.
* Tomorrow (Thursday) is the first valid day.
* The second valid day will be Fridary (first business day).
* Fourth business day will be Tuesday (Saturday and Sunday are not in scope).

```console
irb(main):001:0> Time.current
=> Wed, 12 Sep 2018 05:49:10 UTC +00:00
irb(main):002:0> period = { 2, 4 }
=> {:from_date=>2, :to_date=>4}
irb(main):003:0> BusinessPeriod::Days.call(period)
=> {:from_date=>Fri, 14 Sep 2018, :to_date=>Tue, 18 Sep 2018]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
