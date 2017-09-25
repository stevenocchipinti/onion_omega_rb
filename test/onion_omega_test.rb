require 'test_helper'
require_relative "../lib/onion_omega/stepper"

class OnionOmegaTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::OnionOmega::VERSION
  end

  def test_full_stepping_works
    gpio = OnionOmega::GPIO.new(dry_mode: true)
    stepper = OnionOmega::Stepper.new(
      range: 100,
      gpio: gpio,
      half_stepping: false
    )
    assert_equal stepper.send(:step), [1,0,0,0] # 0
    assert_equal stepper.send(:step), [0,1,0,0] # 1
    assert_equal stepper.send(:step), [0,0,1,0] # 2
    assert_equal stepper.send(:step), [0,0,0,1] # 3

    assert_equal stepper.send(:step), [1,0,0,0] # 0
    assert_equal stepper.send(:step), [0,1,0,0] # 1
    assert_equal stepper.send(:step), [0,0,1,0] # 2
    assert_equal stepper.send(:step), [0,0,0,1] # 3
  end

  def test_half_stepping_works
    gpio = OnionOmega::GPIO.new(dry_mode: true)
    stepper = OnionOmega::Stepper.new(
      range: 100,
      gpio: gpio,
      half_stepping: true
    )

    assert_equal stepper.send(:step), [1,0,0,0] # 0
    assert_equal stepper.send(:step), [1,1,0,0] # 1
    assert_equal stepper.send(:step), [0,1,0,0] # 2
    assert_equal stepper.send(:step), [0,1,1,0] # 3
    assert_equal stepper.send(:step), [0,0,1,0] # 4
    assert_equal stepper.send(:step), [0,0,1,1] # 5
    assert_equal stepper.send(:step), [0,0,0,1] # 6
    assert_equal stepper.send(:step), [1,0,0,1] # 7
  end
end
