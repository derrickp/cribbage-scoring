# frozen_string_literal: true

require "cribbage/card"

module Cribbage
  class Deck
    attr_accessor :cards
    def initialize
      @all_cards = []
      suits = [ Cribbage::Suits::HEARTS, Cribbage::Suits::SPADES, Cribbage::Suits::DIAMONDS, Cribbage::Suits::CLUBS ]
      names = [
        Cribbage::CardNames::ACE,
        Cribbage::CardNames::TWO,
        Cribbage::CardNames::THREE,
        Cribbage::CardNames::FOUR,
        Cribbage::CardNames::FIVE,
        Cribbage::CardNames::SIX,
        Cribbage::CardNames::SEVEN,
        Cribbage::CardNames::EIGHT,
        Cribbage::CardNames::NINE,
        Cribbage::CardNames::TEN,
        Cribbage::CardNames::JACK,
        Cribbage::CardNames::QUEEN,
        Cribbage::CardNames::KING
      ]
      suits.each { |suit|
      names.each { |name|
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
