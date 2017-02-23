require 'journey'
require 'station'
require 'oystercard'

describe Journey do
  let(:shoreditch) {double(:station)}
  let(:angel) {double(:station)}
  let(:oyster) {double(:oystercard)}
  subject(:journey) {described_class.new(shoreditch)}
  bank = Station.new('Bank')
  kilburn = Station.new('Kilburn')
  card = Oystercard.new

  describe 'initialization' do

    it "is initialized with complete = false by default " do
      expect(journey.complete?).to eq false
    end
  end

  it "records journey as complete when ending a journey" do
    journey.end_journey(angel)
    expect(journey.complete?).to eq true
  end


  it 'saves the entry station on touch_in', :entry => true do
    expect(journey.entry_station).to eq shoreditch
  end

  it "remembers the entry station" do
  #  allow(oyster).to receive(:touch_in).with(bank)
  #  allow(oyster).to receive(:top_up).with 5
    card.top_up(5)
    card.touch_in(bank)
    expect(card.journey.entry_station).to eq(bank)
  end

  it "remembers the exit station" do
  #  allow(oyster).to receive(:touch_in).with(bank)
  #  allow(oyster).to receive(:top_up).with 5
    card.top_up(5)
    card.touch_in(bank)
    card.touch_out(kilburn)
    expect(card.history.last.values).to include(kilburn)
  end

  it "calculates the normal fare as the minimum fare" do
    card.top_up(10)
    card.touch_in(bank)
    card.touch_out(kilburn)
    expect(card.journey.calculate_fare).to eq(Oystercard::MINIMUM_FARE)
  end

  it "calculates the penalty fare when no touch out" do
    card.top_up(10)
    card.touch_in(kilburn)
    # card.touch_out(nil)
    expect(card.journey.calculate_fare).to eq(Oystercard::PENALTY_FARE)
  end


  #
  # describe "fare" do
  #   it "charges the minimum fare" do
  #
  #   end
  # end


end
