# frozen_string_literal: true

class BowlingGame
  def initialize
    @rolls = []
  end

  def roll(pin_count)
    @rolls << pin_count
  end

  def score
    @rolls.sum
  end
end
