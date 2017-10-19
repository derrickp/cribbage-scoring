
# frozen_string_literal: true

module Cards
  module Suits
    HEARTS = :hearts
    SPADES = :spades
    CLUBS = :clubs
    DIAMONDS = :diamonds
  end

  # A convenient way of getting all of the suits as an iterable
  ALL_SUITS = [
    Suits::HEARTS,
    Suits::SPADES,
    Suits::CLUBS,
    Suits::DIAMONDS
  ].freeze
end
