require_relative './gpio'

class OnionOmega::Stepper
  def initialize(
    range:,
    pins: [0, 1, 2, 3],
    half_stepping: false,
    persist_to_file: nil,
    gpio: OnionOmega::GPIO.new
  )
    @range = range
    @pins = pins
    @half_stepping = half_stepping
    @file = persist_to_file
    @current_step = (@file && File.exists?(@file)) ? File.read(@file).to_i : 0
    @gpio = gpio
    initialise_gpio
  end

  def forward(steps: 1)
    steps.times { step(1) }
  end

  def backward(steps: 1)
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
    set_pins(*@half_stepping ? half_step : full_step).tap do
      @current_step += increment
      File.write @file, @current_step if @file
    end
  end

  def full_step
    @pins.each_with_index.map do |pin, index|
      phase = @current_step % @pins.size
      index == phase ? 1 : 0
    end
  end

  def half_step
    phase = @current_step % (@pins.size * 2)
    @pins.each_with_index.map do |pin, index|
      case index * 2
      when phase, phase - 1, (phase + 1) % (@pins.size * 2)
        1
      else
        0
      end
    end
  end

  def set_pins(*pins)
    pins.each_with_index do |value, index|
      @gpio.set @pins[index], value
    end
  end
end
