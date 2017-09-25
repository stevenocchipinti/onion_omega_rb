require_relative "test_helper"
require_relative "../lib/onion_omega/stepper_sequencer"

class OnionOmegaTest < Minitest::Test
  def test_full_stepping_works
    sequencer = OnionOmega::StepperSequencer.new(
      number_of_pins: 4,
      half_stepping: false
    )

    assert_equal sequencer.pins_for_step(0), [1,0,0,0] # 0
    assert_equal sequencer.pins_for_step(1), [0,1,0,0] # 1
    assert_equal sequencer.pins_for_step(2), [0,0,1,0] # 2
    assert_equal sequencer.pins_for_step(3), [0,0,0,1] # 3

    assert_equal sequencer.pins_for_step(4), [1,0,0,0] # 0
    assert_equal sequencer.pins_for_step(5), [0,1,0,0] # 1
    assert_equal sequencer.pins_for_step(6), [0,0,1,0] # 2
    assert_equal sequencer.pins_for_step(7), [0,0,0,1] # 3
  end

  def test_half_stepping_works
    sequencer = OnionOmega::StepperSequencer.new(
      number_of_pins: 4,
      half_stepping: true
    )

    assert_equal sequencer.pins_for_step(0),  [1,0,0,0] # 0
    assert_equal sequencer.pins_for_step(1),  [1,1,0,0] # 1
    assert_equal sequencer.pins_for_step(2),  [0,1,0,0] # 2
    assert_equal sequencer.pins_for_step(3),  [0,1,1,0] # 3
    assert_equal sequencer.pins_for_step(4),  [0,0,1,0] # 4
    assert_equal sequencer.pins_for_step(5),  [0,0,1,1] # 5
    assert_equal sequencer.pins_for_step(6),  [0,0,0,1] # 6
    assert_equal sequencer.pins_for_step(7),  [1,0,0,1] # 7

    assert_equal sequencer.pins_for_step(8),  [1,0,0,0] # 0
    assert_equal sequencer.pins_for_step(9),  [1,1,0,0] # 1
    assert_equal sequencer.pins_for_step(10), [0,1,0,0] # 2
    assert_equal sequencer.pins_for_step(11), [0,1,1,0] # 3
    assert_equal sequencer.pins_for_step(12), [0,0,1,0] # 4
    assert_equal sequencer.pins_for_step(13), [0,0,1,1] # 5
    assert_equal sequencer.pins_for_step(14), [0,0,0,1] # 6
    assert_equal sequencer.pins_for_step(15), [1,0,0,1] # 7
  end
end
