
require "cribbage/hand"

module Cribbage

  # A module that provides utilities for scoring a hand of crib
  module Scoring
    def self.score_hand(hand)
      points = 0
      points += self.score_pairs(hand)
      return points
    end

    # Score the number of matching cards in the hand
    def self.score_pairs(hand)
      points = 0
      # 1. Create a hash for each card to the number of them in the hand
      card_count = Hash.new { |hash, key| hash[key] = 0 }
      # 2. Loop through the cards in the hand and count the number of each card (ignoring suit)
      hand.cards.each { |card|
        card_count[card.name] += 1
      }

      card_count[hand.cut_card.name] += 1 unless hand.cut_card.nil?

      card_count.values.each { |count|
        if count == 2
          points += 2
        elsif count == 3
          points += 6
        elsif count == 4
          points += 12
        end
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
  end
end