require "spec_helper"

RSpec.describe Cribbage do
  it "has a version number" do
    expect(Cribbage::VERSION).not_to be nil
  end
end

RSpec.describe Cribbage::Card do
  it "can create a card with a suit and name" do
    suit = Cribbage::SUITS.fetch(0)
    name = Cribbage::CARD_NAMES.fetch(0)
    card = Cribbage::Card.new(suit, name)
    expect(card).not_to be nil
  end

  it "to_s gives a full description of the card" do
    suit = Cribbage::SUITS.fetch(0)
    name = Cribbage::CARD_NAMES.fetch(0)
    card = Cribbage::Card.new(suit, name)
    full = card.to_s.downcase
    suit_match = full[/hearts|clubs|spades|diamonds/]
    expect(suit_match).not_to be nil
    name_match = full[/ace|two|three|four|five|six|seven|eight|nine|ten|jack|queen|king/]
    expect(name_match).not_to be nil
  end
end

RSpec.describe Cribbage::Deck do
  it "can create a full deck of 52 cards" do
    deck = Cribbage::Deck.new
    expect(deck.cards.length).to eq 52
  end

  it "can draw a card from the deck" do
    deck = Cribbage::Deck.new
    card = deck.draw
    expect(card).not_to be nil
    expect(card.class).to eq Cribbage::Card
  end

  it "never draws the same card twice from the deck" do
    deck = Cribbage::Deck.new
    cards = []
    (1..52).each {
      card = deck.draw
      expect(cards.include?(card)).to eq false
      cards << card
    }
    expect(cards.length).to eq 52
    expect(deck.cards.length).to eq 0
  end

  it "can reset the deck" do
    deck = Cribbage::Deck.new
    (1..52).each {
      deck.draw
    }
    expect(deck.cards.length).to eq 0 # Shouldn't be any cards in the deck if we've drawn 52
    deck.reset
    expect(deck.cards.length).to eq 52 #We've reset the deck, should be 52 again 
  end
end
