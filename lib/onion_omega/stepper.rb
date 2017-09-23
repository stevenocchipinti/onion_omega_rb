require_relative './gpio'

class OnionOmega::Stepper
  def initialize(
    max_steps:,
    pins: [0, 1, 2, 3],
    persist_to_file: nil,
    gpio: OnionOmega::GPIO.new(dry_mode: true)
  )
    @max_steps = max_steps
    @pins = pins
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
    desired_step = (percentage * @max_steps).round
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
    new_pins = @pins.each_with_index.map do |pin, index|
      index == (@current_step % @pins.size) ? 1 : 0
    end
    set_pins(*new_pins)
    @current_step += increment
    File.write @file, @current_step if @file
  end

  def set_pins(*pins)
    pins.each_with_index do |value, index|
      @gpio.set @pins[index], value
    end
  end
end
