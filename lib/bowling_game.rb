# frozen_string_literal: true

class BowlingGame
  def initialize
    @rolls = []
  end

  def roll(pin_count)
    @rolls << pin_count
  end

  def score
    sum = 0
    @rolls.size.times do |i|
      sum += @rolls[i]

      if (i >= 2) && i.even? && (@rolls[i - 2] + @rolls[i - 1] == 10)
        sum += @rolls[i]
      end
    end

    sum
  end
end
