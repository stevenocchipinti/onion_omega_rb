OnionOmega
==========

A Ruby wrapper for the `fast-gpio` command line tool found on the Onion Omega
base operating system.

This gem provides a basic `GPIO` class and a `Stepper` class that uses the GPIO
pins to drive a stepper motor.


Installation
------------

Add this line to your application's Gemfile:

```ruby
gem 'onion_omega'
```

And then execute `bundle`


Usage
-----

The `GPIO` class simply wraps the `fast-gpio` command line tool and has a
similar interface:

```ruby
gpio = OnionOmega::GPIO.new(dry_mode: false)  # dry_mode defaults to false
gpio.set_output 0                             # Sets pin 0 to be an output pin
gpio.set 0, 1                                 # Sets pin 0 to HIGH (on with 3v)
```

The `Stepper` class uses the GPIO class above to perform sequence of operations
to drive a stepper motor:

```ruby
stepper = OnionOmega::Stepper.new(
  range: 1000,                # Required. Used to calculate steps for percentage
  pins: [0, 1, 2, 3],         # Defaults. Which pins used to drive stepper motor
  half_stepping: false,       # Defaults. Whether to use full or half stepping
  persist_to_file: nil,       # Defaults. Persist position to file at every step
  gpio: GPIO.new              # Defaults. Allow GPIO object to be overridden
)

stepper.forward 1             # Defaults. Move forward 1 step
stepper.backward 1            # Defaults. Move backward 1 step
stepper.set_percentage 0.1    # Required. Move to percentage based on range
stepper.reset                 # Move to 0% based on current position and range
```

While `range` is a required parameter, it is only used for
`Stepper#set_percentage` and `Stepper#reset`.

The option to override the `GPIO` object is useful for testing to allow a `GPIO`
object that has `dry_mode` enabled to passed in which will only result in STDOUT
messages instead of actual commands being executed.


Development
-----------

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake test` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).


Contributing
------------

Bug reports and pull requests are welcome on GitHub at
https://github.com/stevenocchipinti/onion_omega.


License
-------

The gem is available as open source under the terms of the [MIT
License](http://opensource.org/licenses/MIT).

