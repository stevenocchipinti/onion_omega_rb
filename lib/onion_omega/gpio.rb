class OnionOmega::GPIO
  attr_accessor :dry_mode

  def initialize(dry_mode: false)
    @dry_mode = dry_mode
  end

  def set(pin, value)
    execute "fast-gpio set #{pin} #{value}"
  end

  def set_output(pin)
    execute "fast-gpio set-output #{pin}"
  end

  private

  def execute(command)
    @dry_mode ? puts(command) : system(command)
  end
end
