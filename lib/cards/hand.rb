# frozen_string_literal: true

require_relative 'support/card_helper'

module Cards
  # Model of a hand of cards.
  # Very basic, does nothing except contain all the cards.
  # Can be extended later
  class Hand
    attr_reader :cards
    def initialize(card_defs = nil)
      @cards = card_defs.nil? ? [] : create_cards(card_defs)
    end

    def add_card(card)
      @cards << card
    end
  end
end
