module OnionOmega
  class StepperSequencer
    attr_accessor :number_of_pins, :half_stepping

    def initialize(number_of_pins: 4, half_stepping: false)
      @number_of_pins = number_of_pins
      @half_stepping = half_stepping
    end

    def pins_for_step(step)
      @half_stepping ? pins_for_half_step(step) : pins_for_full_step(step)
    end

    private

    def pins_for_full_step(step)
      @number_of_pins.times.map do |index|
        phase = step % @number_of_pins
        index == phase ? 1 : 0
      end
    end

    def pins_for_half_step(step)
      phase = step % (@number_of_pins * 2)
      @number_of_pins.times.map do |index|
        case index * 2
        when phase, phase - 1, (phase + 1) % (@number_of_pins * 2)
          1
        else
          0
        end
      end
    end
  end
end
