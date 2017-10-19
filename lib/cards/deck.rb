# frozen_string_literal: true

require "cards/names"

module Cards
  class Deck
    attr_accessor :cards
    def initialize
      @all_cards = []
      suits = [ Cards::Suits::HEARTS, Cards::Suits::SPADES, Cards::Suits::DIAMONDS, Cards::Suits::CLUBS ]
      names = [
        Cards::Names::ACE,
        Cards::Names::TWO,
        Cards::Names::THREE,
        Cards::Names::FOUR,
        Cards::Names::FIVE,
        Cards::Names::SIX,
        Cards::Names::SEVEN,
        Cards::Names::EIGHT,
        Cards::Names::NINE,
        Cards::Names::TEN,
        Cards::Names::JACK,
        Cards::Names::QUEEN,
        Cards::Names::KING
      ]
      suits.each { |suit|
      names.each { |name|
          card = Cards::Card.new(suit, name)
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
