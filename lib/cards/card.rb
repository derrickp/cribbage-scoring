# frozen_string_literal: true

module Cards
  # Models a single card from a basic deck
  class Card
    attr_accessor :suit
    attr_accessor :name
    def initialize(suit, name)
      @suit = suit
      @name = name
    end

    def to_s
      "#{name} of #{suit}"
    end
  end
end
