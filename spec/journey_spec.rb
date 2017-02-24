require 'journey'
require 'station'
require 'oystercard'

describe Journey do
  let(:shoreditch) {double(:station)}
  # let(:angel) {double(:station)}
  # let(:oyster) {double(:oystercard, :touch_in(station), :touch_out(station))}
  subject(:journey) {described_class.new}
  bank = Station.new('Bank')
  angel = Station.new('Angel')
  card = Oystercard.new


  describe 'initialization' do

    it "is initialized with complete = false by default " do
      expect(journey.complete?).to eq false
    end
  end

  it "records journey as complete when ending a journey" do
    journey.start_journey(bank)
    journey.end_journey(angel)
    expect(journey.complete?).to eq true
  end

describe "touching in and out" do

  before :each do
    card.top_up(10)
    card.touch_in(bank)
  end

  it 'saves the entry station on touch_in' do
    expect(card.journey.journey_log[0][:entry]).to eq(bank)
  end

  it "saves the exit station on touch out" do
    card.touch_out(angel)
    expect(card.journey.journey_log[1][:exit]).to eq(angel)
  end


  it "calculates the normal fare as the minimum fare" do
    card.touch_in(bank)
    card.touch_out(angel)
    expect(card.journey.calculate_fare).to eq(Oystercard::MINIMUM_FARE)
  end


describe "no touch out" do

  it "calculates the penalty fare when no touch out" do
    expect(card.journey.calculate_fare).to eq(Oystercard::PENALTY_FARE)
  end
end

describe "no touch in" do

  it "calculates the penalty fare when no touch in" do
    card = Oystercard.new
    card.top_up(10)
    card.touch_out(bank)
    expect(card.journey.calculate_fare).to eq(Oystercard::PENALTY_FARE)
  end
end

end


end
