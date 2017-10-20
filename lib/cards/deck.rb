# frozen_string_literal: true

require 'cards/names'

module Cards
  # Models a deck of cards.
  # Initializes with 52 cards in the deck and randomizes them
  class Deck
    attr_accessor :cards
    def initialize
      @all_cards = []
      SUITS.each do |suit|
        NAMES.each { |name| @all_cards << Cards::Card.new(name, suit) }
      end
      @cards = @all_cards.shuffle
    end

    def draw
      # cards have been shuffled in init.
      # pop the next one off the array
      @cards.pop
    end

    def reset
      @cards.clear
      @cards = @all_cards.shuffle
    end
  end
end
