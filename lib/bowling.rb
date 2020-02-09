# frozen_string_literal: true

require 'gif_client'

# Bowling ...
class Bowling
  def initialize
    @rolls = []
  end

  def roll(pin_count)
    if pin_count < 0
      raise("Even I cannot roll minus pins, you loser!")
    end

    if pin_count > 10
      raise('Liar Liar Pants On Fire')
    end

    @rolls << pin_count
    nil
  end

  def score
    roll_index = 0
    result = 0

    10.times do
      if strike?(roll_index)
        result += 10 + strike_bonus(roll_index)
        roll_index += 1
        next
      end

      if spare?(roll_index)
        result += 10 + spare_bonus(roll_index)
        roll_index += 2
        next
      end

      result += open_frame_score(roll_index)
      roll_index += 2
    end

    result
  end

  def celebrate(gif_client = GifClient.new)
    puts gif_client.gif_for('lebowski jesus')
  rescue
    puts 'Sorry, will celebrate tomorrow.'
  end

  private

  def strike?(roll_index)
    @rolls[roll_index] == 10
  end

  def spare?(roll_index)
    @rolls[roll_index] + @rolls[roll_index + 1] == 10
  end

  def open_frame_score(roll_index)
    @rolls[roll_index] + @rolls[roll_index + 1]
  end

  def spare_bonus(roll_index)
    @rolls[roll_index + 2]
  end

  def strike_bonus(roll_index)
    @rolls[roll_index + 1] + @rolls[roll_index + 2]
  end
end
