# frozen_string_literal: true

module Cards
  # Model of a hand of cards.
  # Very basic, does nothing except contain all the cards.
  # Can be extended later
  class Hand
    attr_reader :cards
    def initialize
      @cards = []
    end

    def add_card(card)
      @cards << card
    end
  end
end
