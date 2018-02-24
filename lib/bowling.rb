# frozen_string_literal: true

require 'gif_client'

# Frame ...
class Frame
  attr_reader :rolls, :index

  def initialize(index, first_roll)
    @index = index
    @rolls = [first_roll]
  end

  def add_second_roll(pin_count)
    @rolls << pin_count
  end

  def ended?
    @rolls.size == 2 || strike?
  end

  def score
    @rolls.sum
  end

  def strike?
    @rolls.first == 10
  end

  def spare?
    score == 10 && !strike?
  end
end

# Bowling ...
class Bowling
  def initialize
    @frames = []
  end

  def roll(pin_count)
    if @frames.empty? || @frames.last.ended?
      @frames << Frame.new(@frames.size, pin_count)
    else
      @frames.last.add_second_roll(pin_count)
    end
    nil
  end

  def score
    frame_scores + spare_bonuses + strike_bonuses
  end

  def celebrate(gif_client = GifClient.new)
    puts gif_client.gif_for('lebowski jesus')
  end

  private

  def frame_scores
    game_frames.sum(&:score)
  end

  def spare_bonuses
    spare_frames.sum { |frame| spare_bonus_for_frame(frame) }
  end

  def strike_bonuses
    strike_frames.sum { |frame| strike_bonus_for_frame(frame) }
  end

  def spare_frames
    game_frames.select(&:spare?)
  end

  def strike_frames
    game_frames.select(&:strike?)
  end

  def spare_bonus_for_frame(frame)
    next_frame(frame).rolls.first
  end

  def strike_bonus_for_frame(frame)
    if next_frame(frame).strike?
      return 10 + next_next_frame(frame).rolls.first
    end

    next_frame(frame).score
  end

  def game_frames
    @frames.take(10)
  end

  def next_frame(frame)
    @frames[frame.index + 1]
  end

  def next_next_frame(frame)
    @frames[frame.index + 2]
  end
end
