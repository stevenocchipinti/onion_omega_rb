require_relative "test_helper"
require_relative "../lib/onion_omega/stepper"
require_relative "../lib/onion_omega/gpio"

class OnionOmegaTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::OnionOmega::VERSION
  end

  def test_smoke_doesnt_come_out
    gpio = OnionOmega::GPIO.new(dry_mode: true)
    stepper = OnionOmega::Stepper.new(
      range: 100,
      gpio: gpio,
      half_stepping: false
    )
    stepper.forward
    stepper.backward
    stepper.set_percentage 10
    stepper.reset
  end
end
