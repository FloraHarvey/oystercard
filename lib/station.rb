require_relative 'zones'

class Station

  include Zones

  attr_reader :zone

  def initialize(name)
    @name = name
    @zone = grab_zone(name)
  end

end
