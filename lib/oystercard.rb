require_relative 'journey'

class Oystercard


  attr_reader :balance, :history, :journey

  def initialize
    @balance = 0
    @history = []
  end

  def touch_in(station)
    fail "Insufficient balance" if @balance < MINIMUM_FARE
    @journey = Journey.new
    journey.start_journey(station)
  end

  def touch_out(station)
    if (@journey == nil)
      @journey = Journey.new
    end

    journey.end_journey(station)
    deduct(journey.calculate_fare)
    @history << journey.journey_log
    # journey.reset_journey
  end




  def top_up(amount)
    fail "Balance limit of £#{LIMIT} reached" if (@balance + amount) > LIMIT
    @balance += amount
  end

  private

  def deduct(fare)
    @balance -= fare
  end

  LIMIT = 90
  MINIMUM_FARE = 1
  PENALTY_FARE = 6

end
