
require "cards"

module Cribbage

  # A tracker for a single game of crib. Created with a number of players.
  # Each round it will deal a new hand to each player, and then score each hand.
  class CribGame
    attr_accessor :deck
    # Initialize our game with a number of players (defaults to one, the world's loneliest crib game)
    def initialize(num_players: 1)
      if (num_players * 5 > 50)
        raise RuntimeError "invalid number of players"
      end

      @deck = Cards::Deck.new
    end
  end
end