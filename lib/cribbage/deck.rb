# frozen_string_literal: true

require "cribbage/card"

module Cribbage
  SUITS = %i[hearts clubs spades diamonds].freeze
  CARD_NAMES = %i[ace two three four five six seven eight nine ten jack queen king].freeze
  class Deck
    attr_accessor :cards
    def initialize
      @all_cards = []
      SUITS.each { |suit|
      CARD_NAMES.each { |name|
          card = Cribbage::Card.new(suit, name)
          @all_cards << card
        }
      }
      @cards = @all_cards.shuffle
    end

    def draw
      # cards have been shuffled in init.
      # pop the next one off the array
      card = @cards.pop
      card
    end

    def reset
      @cards.clear
      @cards = @all_cards.shuffle
    end
  end
end
