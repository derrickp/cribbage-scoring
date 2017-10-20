# frozen_string_literal: true

require 'cribbage/player'

module Cribbage
  # A tracker for a single game of crib. Created with a number of players.
  # Each round it will deal a new hand to each player, and then score each hand.
  class Game
    attr_reader :deck
    attr_reader :players
    # Initialize our game with a number of players
    # (defaults to two)
    def initialize(num_players: 2)
      raise RuntimeError('invalid number of players') if num_players < 2 || num_players > 6
      @players = []
      num_players.times { |num| @players << Cribbage::Player.new("Player #{num + 1}") }
      @deck = Cards::Deck.new
      # Keep track of the index of the dealer
      @dealer = 0
    end

    def deal
      # In a 2-player game they will both get 6 cards and discard 2 into the crib
      # Otherwise, each player gets 5 cards and the first 4 after the dealer
      # (and possibly including the dealer) will discard into the crib
      # With the rest just discarding cards from their hand
      num_cards = @players.length == 2 ? 6 : 5
      num_cards.times do |num|
        @players.each do |player|
          player.hand = Cribbage::Hand.new if num.zero?
          player.hand.cards << @deck.draw
        end
      end
    end
  end
end
