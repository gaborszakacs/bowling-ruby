# frozen_string_literal: true

require 'bowling'

RSpec.describe Bowling do
  describe '#score' do
    test_cases = [
      {
        name: 'Gutter game',
        rolls: [
          0, 0,
          0, 0,
        ],
        score: 0
      },
    ]

    test_cases.each do |tc|
      it "returns #{tc[:score]} for #{tc[:name]}" do
        game = Bowling.new
        tc[:rolls].each { |roll| game.roll roll }

        expect(game.score).to eq tc[:score]
      end
    end
  end
end
