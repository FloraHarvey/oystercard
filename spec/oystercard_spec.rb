require 'oystercard'

describe Oystercard do
  subject(:oystercard) { described_class.new}
  let(:euston) {double(:station)}
  let(:exit_station) {double(:station)}
  let(:journey) {double(:journey)}

  let(:bank) {double(:station)}
  let(:angel) {double(:station)}
  let(:kilburn) {double(:station)}
  # bank = Station.new("Bank")
  # angel = Station.new("Angel")
  # kilburn = Station.new("Kilburn")

  limit = Oystercard::LIMIT
  min_fare = Journey::MINIMUM_FARE
  penalty = Journey::PENALTY_FARE


  describe "initialization" do
    it "has a balance of 0 by default" do
      expect(oystercard.balance).to eq(0)
    end

    it "expects journey history to be empty by default" do
      expect(oystercard.history).to be_empty
    end
  end

  context "balance too low" do
    it "raises an error if balance is less than £#{min_fare} when touching in" do
      expect{oystercard.touch_in(euston)}.to raise_error "Insufficient balance"
    end
  end

    describe "using the card" do
    before (:each) { oystercard.top_up(10) }

      describe ".top_up" do
        it "adds the amount to the balance" do
          expect{oystercard.top_up(10)}.to change{ oystercard.balance }.by 10
        end

        it "will not top up over maximum balance of £#{limit}" do
          expect{10.times{oystercard.top_up(10)}}.to raise_error "Balance limit of £#{limit} reached"
        end
      end

      describe "normal usage of card" do
        before :each do
          oystercard.touch_in(bank)
        end

        describe "history" do
          it "shows that history saves entry and exit stations" do
            oystercard.touch_out(angel)
            expect(oystercard.history).to eq([[{:entry => bank}, {:exit => angel}]])
          end
        end

        describe ".touch_out" do

          it "resets journey" do
            expect{oystercard.touch_out(angel)}.to change{oystercard.journey}.to (nil)
          end

          it "deducts minimum fare" do
            expect{oystercard.touch_out(exit_station)}.to change{ oystercard.balance }.by -min_fare
          end

        end
      end

      describe "no touch out" do
        it "calculates the penalty fare when no touch out" do
          oystercard.touch_in(bank)
          expect{ oystercard.touch_in(angel) }.to change{ oystercard.balance }.by -penalty
        end

        it "after touching in twice it saves first entry station" do
          oystercard.touch_in(bank)
          oystercard.touch_in(angel)
          expect(oystercard.history).to match_array([[{:entry => bank}]])
        end


      end

      describe "no touch in" do

        it "calculates the penalty fare when no touch in, after completing a previous journey" do
          oystercard.touch_in(kilburn)
          oystercard.touch_out(bank)
          expect{oystercard.touch_out(angel)}.to change{ oystercard.balance}.by -penalty
        end
      end

    end
  end
