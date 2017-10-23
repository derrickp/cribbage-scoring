
# frozen_string_literal: true

require_relative 'hand'
require_relative 'support/score_helper'

module Cribbage
  class BasicScore
    def initialize(hand)
      @hand = hand
      @all_cards = [].concat(hand.cards)
      @all_cards.push(@hand.cut_card) unless @hand.cut_card.nil?
    end

    def fifteens
      count = ScoreHelper.num_fifteens(@all_cards)
      count * 2
    end

    def flushes
      is_flush = ScoreHelper.flush?(@hand.cards)
      cut_match = @hand.cut_card.suit == @hand.cards.first.suit
      min_score = @hand.cards.length
      return min_score + 1 if is_flush && cut_match
      return min_score if !@hand.is_crib && is_flush
      0
    end

    def nobs
      # Do not score nobs in crib
      return 0 if @hand.is_crib
      return 0 if @hand.cut_card.nil?

      matching = @hand.cards.any? { |card| card.name == :jack && card.suit == @hand.cut_card.suit }
      matching ? 1 : 0
    end

    def pairs
      count = ScoreHelper.num_pairs(@all_cards)
      count * 2
    end

    def runs
      run_size = @all_cards.length
      score = 0

      # Loop as long as our runs wouldn't get too small, or we have score.
      # Once we've scored a certain length of run (ex: 4)
      # We don't want to score any smaller runs than that
      while run_size >= 3 && score.zero?
        combos = @all_cards.combination(run_size)
        score = combos.reduce(0) { |sum, combo| sum + (ScoreHelper.run?(combo) ? combo.length : 0) }
        run_size -= 1
      end
      score
    end

    def total
      score = 0
      score += fifteens
      score += flushes
      score += nobs
      score += pairs
      score += runs
    end
  end
end
