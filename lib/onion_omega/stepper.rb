require_relative "./gpio"
require_relative "./stepper_sequencer"

module OnionOmega
  class Stepper
    def initialize(
      range:,
      pins: [0, 1, 2, 3],
      half_stepping: false,
      persist_to_file: nil,
      gpio: GPIO.new
    )
      @range = range
      @pins = pins
      @sequencer = StepperSequencer.new(
        number_of_pins: @pins.count,
        half_stepping:  half_stepping
      )
      @file = persist_to_file
      @current_step = (@file && File.exists?(@file)) ? File.read(@file).to_i : 0
      @gpio = gpio
      initialise_gpio
    end

    def forward(steps=1)
      steps.times { step(1) }
    end

    def backward(steps=1)
      steps.times { step(-1) }
    end

    def set_percentage(percentage)
      desired_step = (percentage * @range).round
      steps = desired_step - @current_step
      if steps > 0
        steps.times { forward }
      elsif steps < 0
        steps.abs.times { backward }
      end
    end

    def reset
      set_percentage 0
    end

    private

    def initialise_gpio
      @pins.each do |pin|
        @gpio.set_output pin
      end
    end

    def step(increment = 1)
      @current_step += increment
      set_pins @sequencer.pins_for_step(@current_step)
      File.write @file, @current_step if @file
    end

    def set_pins(pins)
      pins.each_with_index do |value, index|
        @gpio.set @pins[index], value
      end
    end
  end
end
