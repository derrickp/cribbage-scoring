
# frozen_string_literal: true

require 'cards/card'

module Cribbage
  # A basic scoring helper
  # Provides utility functions for counting runs, pairs, fifteens
  # Also provides functions for determing if cards are a run or flush
  class ScoreHelper
    FIFTEEN_VALUES = {
      ace: 1,
      two: 2,
      three: 3,
      four: 4,
      five: 5,
      six: 6,
      seven: 7,
      eight: 8,
      nine: 9,
      ten: 10,
      jack: 10,
      queen: 10,
      king: 10
    }.freeze

    RUN_VALUES = {
      ace: 1,
      two: 2,
      three: 3,
      four: 4,
      five: 5,
      six: 6,
      seven: 7,
      eight: 8,
      nine: 9,
      ten: 10,
      jack: 11,
      queen: 12,
      king: 13
    }.freeze

    def num_pairs(cards)
      return 0 if cards.empty?
      combinations = cards.combination(2)
      combinations.count { |combo| pair?(combo[0], combo[1]) }
    end

    def pair?(card1, card2)
      card1.name == card2.name
    end

    def flush?(cards)
      cards.map(&:suit).uniq.length == 1
    end

    def num_fifteens(cards)
      return 0 if cards.empty?
      combinations = get_card_combinations(cards, 2)
      combinations.count { |combo| fifteen?(combo) }
    end

    def fifteen?(cards)
      total = cards.reduce(0) { |sum, card| sum + FIFTEEN_VALUES[card.name] }
      total == 15
    end

    def get_card_combinations(cards, min_size)
      combos = []
      len = cards.length
      return cards if len <= min_size
      (min_size..len).each { |num| combos.concat(cards.combination(num).to_a) }
      combos
    end

    def run?(cards)
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
  end
end
