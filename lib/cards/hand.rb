
module Cards
  class InvalidCardError < RuntimeError
  end

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