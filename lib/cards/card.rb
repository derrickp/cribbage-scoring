# frozen_string_literal: true

module Cards
  # Models a single card from a basic deck
  class Card
    attr_accessor :name
    attr_accessor :suit
    def initialize(name, suit)
      @name = name
      @suit = suit
    end

    def to_s
      "#{name} of #{suit}"
    end
  end
end
