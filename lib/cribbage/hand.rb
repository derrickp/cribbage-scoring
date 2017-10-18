
require "cribbage/card"

module Cribbage
  class InvalidCardError < RuntimeError
  end
  class Hand
    attr_reader :cards
    def initialize
      @cards = []
    end

    def add_card(card)
      is_card = card.class == Cribbage::Card
      if (!is_card)
        raise InvalidCardError
      end
      @cards << card
    end
  end

  class CribHand < Hand
    attr_accessor :cut_card
    attr_accessor :is_crib
  end
end