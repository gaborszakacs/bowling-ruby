# frozen_string_literal: true

require 'bowling_game'

RSpec.describe BowlingGame do
  describe '#score' do
    test_cases = [
      {
        name: 'Simple game',
        rolls: [
          1, 2,
          3, 4,
          1, 3,
        ],
        score: 3 + 7 + 4
      },

      # TODO: Implement this
      {
        name: 'Spare game',
        rolls: [
          1, 2,
          1, 9,
          1, 2,
        ],
        score: 3 + 10 + 1 + 3
      },
    ]

    test_cases.each do |tc|
      it "returns #{tc[:score]} for #{tc[:name]}" do
        game = BowlingGame.new
        tc[:rolls].each { |roll| game.roll roll }

        expect(game.score).to eq tc[:score]
      end
    end
  end
end
