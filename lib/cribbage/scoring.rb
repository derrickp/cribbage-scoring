
require "cribbage/hand"

module Cribbage

  FIFTEEN_VALUES = {
    Cribbage::CardNames::ACE => 1,
    Cribbage::CardNames::TWO => 2,
    Cribbage::CardNames::THREE => 3,
    Cribbage::CardNames::FOUR => 4,
    Cribbage::CardNames::FIVE => 5,
    Cribbage::CardNames::SIX => 6,
    Cribbage::CardNames::SEVEN => 7,
    Cribbage::CardNames::EIGHT => 8,
    Cribbage::CardNames::NINE => 9,
    Cribbage::CardNames::TEN => 10,
    Cribbage::CardNames::JACK => 10,
    Cribbage::CardNames::QUEEN => 10,
    Cribbage::CardNames::KING => 10
  }

  RUN_VALUES = {
    Cribbage::CardNames::ACE => 1,
    Cribbage::CardNames::TWO => 2,
    Cribbage::CardNames::THREE => 3,
    Cribbage::CardNames::FOUR => 4,
    Cribbage::CardNames::FIVE => 5,
    Cribbage::CardNames::SIX => 6,
    Cribbage::CardNames::SEVEN => 7,
    Cribbage::CardNames::EIGHT => 8,
    Cribbage::CardNames::NINE => 9,
    Cribbage::CardNames::TEN => 10,
    Cribbage::CardNames::JACK => 11,
    Cribbage::CardNames::QUEEN => 12,
    Cribbage::CardNames::KING => 13
  }

  # A module that provides utilities for scoring a hand of crib
  module Scoring
    def self.score_hand(hand)
      points = 0
      points += self.score_pairs(hand)
      points += self.score_fifteens(hand)
      points += self.score_runs(hand)
      points += self.score_flush(hand)
      points += self.score_nobs(hand)
      return points
    end

    # Score the number of matching cards in the hand
    def self.score_pairs(hand)
      points = 0
      
      full_hand = [].concat(hand.cards)
      full_hand.push(hand.cut_card) unless hand.cut_card.nil?

      duos = full_hand.combination(2)
      duos.each { |duo|
        points += 2 if duo[0].name == duo[1].name
      }
      return points
    end

    def self.score_nobs(hand)
      points = 0
      
      # Don't score nobs in a crib
      if !hand.is_crib.nil? && hand.is_crib
        return points
      end

      # If there is no cut card, we can't score nobs
      return points if hand.cut_card.nil?

      # 1. Get all the jacks from the hand
      matching_jacks = hand.cards.select { |card| card.name == Cribbage::CardNames::JACK && card.suit == hand.cut_card.suit }

      #2. We have a matching jack? Score a point
      points += 1 if matching_jacks.length > 0
      return points
    end

    def self.score_flush(hand)
      suit = hand.cards.fetch(0).suit
      is_flush = hand.cards.all? { |card| card.suit == suit }
      match_cut = hand.cut_card.nil? ? false : hand.cut_card.suit === suit

      # If it's not a flush, no points
      return 0 unless is_flush

      # If it matches the cut card, it's 5 points
      return 5 if match_cut

      # If it doesn't match the cut, it's 4 points, unless it's a crib
      return 4 unless hand.is_crib

      # Everything else is 0 points
      return 0
    end

    def self.score_runs(hand)
      points = 0

      full_hand = [].concat(hand.cards)
      full_hand.push(hand.cut_card) unless hand.cut_card.nil?
      is_run = self.is_run(full_hand)

      # Score a point for every card in the hand if it's a run
      return full_hand.length if is_run

      run_size = full_hand.length - 1

      # Loop as long as our runs wouldn't get too small, or we have points.
      # Once we've scored a certain length of run (ex: 4)
      # We don't want to score any smaller runs than that
      while run_size >= 3 && points == 0
        combos = full_hand.combination(run_size)
        combos.each { |combo|
          is_run = self.is_run(combo)
          points += combo.length if is_run
        }
        run_size -= 1
      end

      # Once we're here, we have the points we should be scoring for the runs
      points
    end

    def self.is_run(cards)
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
      return true
    end

    def self.score_fifteens(hand)
      points = 0
      full_hand = [].concat(hand.cards)
      full_hand.push(hand.cut_card) unless hand.cut_card.nil?
      combinations = self.get_card_combinations(full_hand, 2)
      combinations.each { |combo|
        total = combo.inject(0) { |sum, card| sum + FIFTEEN_VALUES[card.name] }
        points += 2 if total == 15
      }
      return points
    end

    def self.get_card_combinations(cards, min_size)
      combos = []
      len = cards.length
      return cards if len <= min_size
      (min_size..len).each { |num|
        combos.concat(cards.combination(num).to_a)
      }
      return combos
    end
  end
end