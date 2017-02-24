require 'station'

describe Station do
  subject(:station) {described_class.new}

  describe "initialization" do
    it "gets the correct zone when given a name" do
      station = Station.new("Euston")
      expect(station.zone).to eq(1)
    end
  end
end
