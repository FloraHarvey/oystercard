class Journey

  attr_reader :journey_log


  def initialize
    @journey_log = []
  end

  def start_journey(station)
    journey_log << {:entry => station}
  end

  def end_journey(station)
    journey_log << {:exit => station}
  end

  def complete?
    journey_log.count == 2
  end

  def calculate_fare
    complete? ? Oystercard::MINIMUM_FARE : Oystercard::PENALTY_FARE
  end

end
