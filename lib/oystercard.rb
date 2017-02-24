require_relative 'journey'

class Oystercard


  attr_reader :balance, :history, :journey

  def initialize
    @balance = 0
    @history = []
  end

  def touch_in(station)
    if journey_exists?
    deduct(journey.calculate_fare)
    add_to_history
    create_journey
    journey.start_journey(station)
    end

    fail "Insufficient balance" if @balance < Journey::MINIMUM_FARE
    create_journey
    journey.start_journey(station)
  end

  def touch_out(station)
    if !journey_exists?
      create_journey
    end

    journey.end_journey(station)
    deduct(journey.calculate_fare)
    add_to_history
    reset_journey
  end

  def top_up(amount)
    fail "Balance limit of £#{LIMIT} reached" if (@balance + amount) > LIMIT
    @balance += amount
  end

  private

  def reset_journey
    @journey = nil
  end

  def journey_exists?
    @journey != nil
  end


  def create_journey
    @journey = Journey.new
  end

  def add_to_history
    @history << journey.journey_log
  end

  def deduct(fare)
    @balance -= fare
  end

  LIMIT = 90

end
