# frozen_string_literal: true

require_relative 'support/card_helper'

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

    def key
      get_name_key(@name) + get_suit_key(@suit)
    end
  end
end
