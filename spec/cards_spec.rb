# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cards::Card do
  it 'can create a card with a suit and name' do
    suit = Cards::Suits::SPADES
    name = Cards::Names::ACE
    card = Cards::Card.new(suit, name)
    expect(card).not_to be nil
  end

  it 'to_s gives a full description of the card' do
    suit = Cards::Suits::SPADES
    name = Cards::Names::ACE
    card = Cards::Card.new(suit, name)
    full = card.to_s.downcase
    suit_match = full[/hearts|clubs|spades|diamonds/]
    expect(suit_match).not_to be nil
    name_match = full[/ace|two|three|four|five|six|seven|eight|nine|ten|jack|queen|king/]
    expect(name_match).not_to be nil
  end
end

RSpec.describe Cards::Deck do
  it 'can create a full deck of 52 cards' do
    deck = Cards::Deck.new
    expect(deck.cards.length).to eq 52
  end

  it 'can draw a card from the deck' do
    deck = Cards::Deck.new
    card = deck.draw
    expect(card).not_to be nil
    expect(card.class).to eq Cards::Card
  end

  it 'never draws the same card twice from the deck' do
    deck = Cards::Deck.new
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
    deck = Cards::Deck.new
    52.times do
      deck.draw
    end
    expect(deck.cards.length).to eq 0 # Shouldn't be any cards in the deck if we've drawn 52
    deck.reset
    expect(deck.cards.length).to eq 52 # We've reset the deck, should be 52 again
  end
end

RSpec.describe Cards::Hand do
  it 'can create an empty hand of cards' do
    hand = Cards::Hand.new
    expect(hand).not_to be nil
  end

  it 'can add a card to the hand' do
    hand = Cards::Hand.new
    suit = Cards::Suits::SPADES
    name = Cards::Names::ACE
    card = Cards::Card.new(suit, name)
    hand.add_card(card)
    expect(hand.cards.length).to eq 1
  end

  it 'invalid cards are not added to the hand' do
    hand = Cards::Hand.new
    error = nil
    begin
      hand.add_card(nil)
    rescue Cards::InvalidCardError => exception
      error = exception
    end
    expect(error.class).to eq Cards::InvalidCardError

    error = nil
    begin
      hand.add_card(2)
    rescue Cards::InvalidCardError => exception
      error = exception
    end
    expect(error.class).to eq Cards::InvalidCardError

    expect(hand.cards.length).to eq 0
  end
end
