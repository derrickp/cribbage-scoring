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
    def initialize(num_players = 2)
      raise RuntimeError('invalid number of players') if num_players < 2 || num_players > 6
      @players = []
      num_players.times { |num| @players << Player.new("Player #{num + 1}") }
      @deck = Cards::Deck.new
      # Keep track of the index of the dealer
      @_dealer = 0
    end

    def dealer
      @players[@_dealer]
    end

    def deal
      @deck.reset
      cut_card = @deck.draw
      # In a 2-player game they will both get 6 cards and discard 2 into the crib
      # Otherwise, each player gets 5 cards and the first 4 after the dealer
      # (and possibly including the dealer) will discard into the crib
      # With the rest just discarding cards from their hand
      num_cards = @players.length == 2 ? 6 : 5
      num_cards.times do |num|
        @players.each do |player|
          if num.zero?
            player.hand = Hand.new
            player.hand.cut_card = cut_card
          end
          player.hand.cards << @deck.draw
        end
      end

      crib = deal_crib(@players, @deck)
      crib.cut_card = cut_card
      self.dealer.crib = crib
    end

    def deal_crib(players, deck)
      # Deal cards to our crib
      crib = Hand.new
      crib.is_crib = true

      # Yep, just grab the last cards
      # Dumbest crib players
      if players.length == 2
        crib.add_card(players[0].hand.cards.pop)
        crib.add_card(players[0].hand.cards.pop)
        crib.add_card(players[1].hand.cards.pop)
        crib.add_card(players[1].hand.cards.pop)
      elsif players.length == 3
        # Everyone discards a card, one is got from the deck
        crib.add_card(players[0].hand.cards.pop)
        crib.add_card(players[1].hand.cards.pop)
        crib.add_card(players[2].hand.cards.pop)
        crib.add_card(deck.draw)
      else
        # 4 people toss into the crib
        while crib.cards.length < 4
          players.each { |player| crib.add_card(player.hand.cards.pop) }
        end
        # Other people just discard
        discard_players = players.select { |player| player.hand.cards.length > 4 }
        discard_players.each { |player| player.hand.cards.pop } unless discard_players.empty?
      end
      crib
    end

    def score
      @players.each do |player|
        player.score = Scoring.score_hand(player.hand)
      end
      self.dealer.score += Scoring.score_hand(self.dealer.crib)
    end
  end
end
