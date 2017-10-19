# frozen_string_literal: true

module Cards
  class InvalidCardError < RuntimeError
  end

  # Model of a hand of cards.
  # Very basic, does nothing except contain all the cards.
  # Can be extended later
  class Hand
    attr_reader :cards
    def initialize
      @cards = []
    end

    def add_card(card)
      is_card = card.class == Cards::Card
      raise InvalidCardError unless is_card
      @cards << card
    end
  end
end
