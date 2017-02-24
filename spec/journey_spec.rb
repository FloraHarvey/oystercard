require 'journey'
require 'station'
require 'oystercard'

describe Journey do
  let(:bank) {double(:station)}
  let(:angel) {double(:station)}
  subject(:journey) {described_class.new}

  describe 'initialization' do

    it "journey log is empty" do
      expect(journey.journey_log).to be_empty
    end
  end

  it "records journey as complete when ending a journey" do
    journey.start_journey(bank)
    journey.end_journey(angel)
    expect(journey.complete?).to eq true
  end

  context 'normal use' do
    it 'returns minimum fare' do
      journey.start_journey(bank)
      journey.end_journey(angel)
      expect(journey.calculate_fare).to eq Journey::MINIMUM_FARE
    end
  end

  context 'journey incomplete' do
    it 'returns penalty fare' do
      journey.start_journey(bank)
      expect(journey.calculate_fare).to eq Journey::PENALTY_FARE
    end
  end
end
