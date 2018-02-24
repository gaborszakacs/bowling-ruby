require 'bowling'
require 'fake_gif_client.rb'

RSpec.describe Bowling do
  let(:game) { Bowling.new }

  def roll_a_spare
    game.roll 3
    game.roll 7
  end

  describe '#roll' do
    let(:roll) { Bowling.new.roll 4 }

    context 'when pin count is between 0-10' do
      it 'does not raise error' do
        game.roll 4
      end
    end

    context 'when pin count is lower than 0' do
      it 'raises error' do
        expect { game.roll(-2) }
          .to raise_error('Even I cannot roll minus pins, you loser!')
      end
    end

    context 'when pin count is higher than 10' do
      it 'raises error' do
        expect { game.roll(11) }
          .to raise_error('Liar Liar Pants On Fire')
      end
    end

    it 'returns nil' do
      expect(roll).to eq nil
    end
  end

  describe '#score' do
    subject { game.score }

    context "when it's a gutter game" do
      before(:each) do
        20.times { game.roll 0 }
      end

      it { is_expected.to eq 0 }
    end

    context "when it's not a gutter game" do
      before(:each) do
        10.times { game.roll 0 }
        10.times { game.roll 1 }
      end

      it "is the sum of the rolls" do
        expect(game.score).to eq 10
      end
    end

    context 'when there is a spare' do
      before(:each) do
        2.times { game.roll 1 }
        roll_a_spare
        16.times { game.roll 1 }
      end

      it 'counts the roll after the spare twice' do
        expect(game.score).to eq 29
      end
    end

    context 'when there are multiple spares' do
      before(:each) do
        roll_a_spare
        2.times { game.roll 2 }
        roll_a_spare
        12.times { game.roll 3 }
        roll_a_spare
        game.roll 5
      end

      it 'counts the roll after the spares twice' do
        expect(game.score).to eq 80
      end
    end

    context 'when there is a strike' do
      before(:each) do
        2.times { game.roll 1 }
        game.roll 10
        game.roll 1
        game.roll 2
        14.times { game.roll 1 }
      end

      it 'counts the two rolls after the strike twice' do
        expect(game.score).to eq 32
      end
    end

    context 'when there are multiple spares and strikes' do
      before(:each) do
        roll_a_spare
        2.times { game.roll 2 }
        roll_a_spare
        game.roll 10
        8.times { game.roll 3 }
        game.roll 10
        roll_a_spare
        game.roll 5
      end

      it 'still works' do
        expect(game.score).to eq 111
      end
    end

    context "when it's a perfect game" do
      before(:each) do
        12.times { game.roll 10 }
      end

      it { is_expected.to eq 300 }
    end
  end

  describe '#celebrate' do
    it 'displays a funny gif (with test gif class)' do
      gif_client = FakeGifClient.new
      expect { game.celebrate(gif_client) }.to output(%r(https://giphy.com/)).to_stdout
      expect(gif_client.terms).to eq ['lebowski jesus']
    end

    it 'displays a funny gif (with mocking)' do
      gif_client = instance_double('GifClient', 'WorkingGifClient')
      expect(gif_client).to receive(:gif_for).with('lebowski jesus').and_return('https://giphy.com/funny.gif')
      expect { game.celebrate(gif_client) }.to output(%r(https://giphy.com/)).to_stdout
    end

    it 'displays a funny gif (with any instance mocking)' do
      expect_any_instance_of(GifClient).to receive(:gif_for).with('lebowski jesus').and_return('https://giphy.com/funny.gif')
      expect { game.celebrate }.to output(%r(https://giphy.com/)).to_stdout
    end

    context 'when client raises error' do
      it 'displays a postponed notice' do
        gif_client = instance_double('GifClient', 'RaisingGifClient')
        allow(gif_client).to receive(:gif_for).and_raise
        expect { game.celebrate(gif_client) }.to output("Sorry, will celebrate tomorrow.\n").to_stdout
      end
    end
  end

  describe '#score (with truth table)' do
    test_cases = [
      {
        name: 'Gutter game',
        rolls: Array.new.tap { |a| 20.times { a << 0 } },
        score: 0
      },
      {
        name: 'Perfect game',
        rolls: Array.new.tap { |a| 12.times { a << 10 } },
        score: 300
      },
      {
        name: 'Game 1',
        rolls: Array.new.tap do |a|
          10.times { a << 4 }
          10.times { a << 3 }
        end,
        score: 70
      },
      {
        name: 'Game 2',
        rolls: [
          3, 5,
          7, 3,
          6, 4,
          2, 5,
          10,
          1, 6,
          2, 7,
          10,
          5, 5,
          6, 4,
          4
        ],
        score: 126
      }
    ]

    test_cases.each do |tc|
      it "is #{tc[:score]} for #{tc[:name]}" do
        tc[:rolls].each { |roll| game.roll roll }
        expect(game.score).to eq tc[:score]
      end
    end
  end
end
