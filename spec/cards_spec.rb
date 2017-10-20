# frozen_string_literal: true

require 'spec_helper'

module Cards
  RSpec.describe Card do
    it 'can create a card with a suit and name' do
      suit = :spades
      name = :ace
      card = Card.new(name, suit)
      expect(card).not_to be nil
    end

    it 'to_s gives a full description of the card' do
      suit = :spades
      name = :ace
      card = Card.new(name, suit)
      full = card.to_s.downcase
      suit_match = full[/hearts|clubs|spades|diamonds/]
      expect(suit_match).not_to be nil
      name_match = full[/ace|two|three|four|five|six|seven|eight|nine|ten|jack|queen|king/]
      expect(name_match).not_to be nil
    end
  end

  RSpec.describe Deck do
    it 'can create a full deck of 52 cards' do
      deck = Deck.new
      expect(deck.cards.length).to eq 52
    end

    it 'can draw a card from the deck' do
      deck = Deck.new
      card = deck.draw
      expect(card).not_to be nil
      expect(card.class).to eq Card
    end

    it 'never draws the same card twice from the deck' do
      deck = Deck.new
      cards = []
      52.times do
        card = deck.draw
        expect(cards.include?(card)).to eq false
        cards << card
      end
      expect(cards.length).to eq 52
      expect(deck.cards.length).to eq 0
    end

    it 'can reset the deck' do
      deck = Deck.new
      52.times do
        deck.draw
      end
      expect(deck.cards.length).to eq 0 # Shouldn't be any cards in the deck if we've drawn 52
      deck.reset
      expect(deck.cards.length).to eq 52 # We've reset the deck, should be 52 again
    end
  end

  RSpec.describe Hand do
    it 'can create an empty hand of cards' do
      hand = Hand.new
      expect(hand).not_to be nil
    end

    it 'can add a card to the hand' do
      hand = Hand.new
      suit = :spades
      name = :ace
      card = Card.new(name, suit)
      hand.add_card(card)
      expect(hand.cards.length).to eq 1
    end
  end
end
