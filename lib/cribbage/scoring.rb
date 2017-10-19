# frozen_string_literal: true

require 'cards'
require 'cribbage/hand'

module Cribbage
  FIFTEEN_VALUES = {
    Cards::Names::ACE => 1,
    Cards::Names::TWO => 2,
    Cards::Names::THREE => 3,
    Cards::Names::FOUR => 4,
    Cards::Names::FIVE => 5,
    Cards::Names::SIX => 6,
    Cards::Names::SEVEN => 7,
    Cards::Names::EIGHT => 8,
    Cards::Names::NINE => 9,
    Cards::Names::TEN => 10,
    Cards::Names::JACK => 10,
    Cards::Names::QUEEN => 10,
    Cards::Names::KING => 10
  }.freeze

  RUN_VALUES = {
    Cards::Names::ACE => 1,
    Cards::Names::TWO => 2,
    Cards::Names::THREE => 3,
    Cards::Names::FOUR => 4,
    Cards::Names::FIVE => 5,
    Cards::Names::SIX => 6,
    Cards::Names::SEVEN => 7,
    Cards::Names::EIGHT => 8,
    Cards::Names::NINE => 9,
    Cards::Names::TEN => 10,
    Cards::Names::JACK => 11,
    Cards::Names::QUEEN => 12,
    Cards::Names::KING => 13
  }.freeze

  # A module that provides utilities for scoring a hand of crib
  module Scoring
    def self.score_hand(hand)
      points = 0
      points += score_pairs(hand)
      points += score_fifteens(hand)
      points += score_runs(hand)
      points += score_flush(hand)
      points += score_nobs(hand)
      points
    end

    # Score the number of matching cards in the hand
    def self.score_pairs(hand)
      full_hand = [].concat(hand.cards)
      full_hand.push(hand.cut_card) unless hand.cut_card.nil?

      duos = full_hand.combination(2)
      duos.inject(0) { |sum, duo| sum + (duo[0].name == duo[1].name ? 2 : 0) }
    end

    def self.score_nobs(hand)
      points = 0

      # Don't score nobs in a crib
      return points if hand.is_crib

      # If there is no cut card, we can't score nobs
      return points if hand.cut_card.nil?

      # 1. Get all the jacks from the hand
      matching_jacks = hand.cards.select do |card|
        card.name == Cards::Names::JACK && card.suit == hand.cut_card.suit
      end

      # 2. We have a matching jack? Score a point
      points += 1 unless matching_jacks.empty?
      points
    end

    def self.score_flush(hand)
      is_flush = flush?(hand.cards)
      cut_match = hand.cut_card.suit == hand.cards.first.suit
      min_points = hand.cards.length
      return min_points + 1 if is_flush && cut_match
      return min_points if !hand.is_crib && is_flush
      0
    end

    def self.flush?(cards)
      cards.map(&:suit).uniq.length == 1
    end

    def self.score_runs(hand)
      points = 0

      full_hand = [].concat(hand.cards)
      full_hand.push(hand.cut_card) unless hand.cut_card.nil?
      run_size = full_hand.length
      # Loop as long as our runs wouldn't get too small, or we have points.
      # Once we've scored a certain length of run (ex: 4)
      # We don't want to score any smaller runs than that
      while run_size >= 3 && points.zero?
        points = score_run(full_hand, run_size)
        run_size -= 1
      end

      # Once we're here, we have the points we should be scoring for the runs
      points
    end

    def self.score_run(cards, run_size)
      combos = cards.combination(run_size)
      combos.inject(0) { |sum, combo| sum + (run?(combo) ? combo.length : 0) }
    end

    def self.run?(cards)
      values = cards.map { |card| RUN_VALUES[card.name] }
      sorted = values.sort
      first = sorted[0]
      last = sorted[-1]
      len = sorted.length

      # If first and last are too far apart, it's not a run
      return false if (last - first) > (len - 1)
      unique = sorted.uniq
      # If all of the values are not unique, it's not a run
      return false if unique != sorted
      # If it passes those, it's a run
      true
    end

    def self.score_fifteens(hand)
      points = 0
      full_hand = [].concat(hand.cards)
      full_hand.push(hand.cut_card) unless hand.cut_card.nil?
      combinations = get_card_combinations(full_hand, 2)
      combinations.each do |combo|
        total = combo.inject(0) { |sum, card| sum + FIFTEEN_VALUES[card.name] }
        points += 2 if total == 15
      end
      points
    end

    def self.get_card_combinations(cards, min_size)
      combos = []
      len = cards.length
      return cards if len <= min_size
      (min_size..len).each { |num| combos.concat(cards.combination(num).to_a) }
      combos
    end
  end
end
