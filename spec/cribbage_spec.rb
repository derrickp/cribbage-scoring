require "spec_helper"

RSpec.describe Cribbage do
  it "has a version number" do
    expect(Cribbage::VERSION).not_to be nil
  end
end

RSpec.describe Cribbage::Card do
  it "can create a card with a suit and name" do
    suit = Cribbage::Suits::SPADES
    name = Cribbage::CardNames::ACE
    card = Cribbage::Card.new(suit, name)
    expect(card).not_to be nil
  end

  it "to_s gives a full description of the card" do
    suit = Cribbage::Suits::SPADES
    name = Cribbage::CardNames::ACE
    card = Cribbage::Card.new(suit, name)
    full = card.to_s.downcase
    suit_match = full[/hearts|clubs|spades|diamonds/]
    expect(suit_match).not_to be nil
    name_match = full[/ace|two|three|four|five|six|seven|eight|nine|ten|jack|queen|king/]
    expect(name_match).not_to be nil
  end
end

RSpec.describe Cribbage::Hand do
  it "can create an empty hand of cards" do
    hand = Cribbage::Hand.new
    expect(hand).not_to be nil
  end

  it "can add a card to the hand" do
    hand = Cribbage::Hand.new
    suit = Cribbage::Suits::SPADES
    name = Cribbage::CardNames::ACE
    card = Cribbage::Card.new(suit, name)
    hand.add_card(card)
    expect(hand.cards.length).to eq 1
  end

  it "invalid cards are not added to the hand" do
    hand = Cribbage::Hand.new
    error = nil
    begin
      hand.add_card(nil)
      rescue => exception
        error = exception
    end
    expect(error.class).to eq Cribbage::InvalidCardError

    error = nil
    begin
      hand.add_card(2)
      rescue => exception
        error = exception
    end
    expect(error.class).to eq Cribbage::InvalidCardError

    expect(hand.cards.length).to eq 0
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

RSpec.describe Cribbage::Scoring do
  it "can score a hand properly for pairs (1 pair)" do
    hand = Cribbage::CribHand.new
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::TWO))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::SPADES, Cribbage::CardNames::TWO))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::NINE))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::KING))
    score = Cribbage::Scoring.score_pairs(hand)
    expect(score).to eq 2
  end

  it "can score a hand properly for pairs (2 pairs)" do
    hand = Cribbage::CribHand.new
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::TWO))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::SPADES, Cribbage::CardNames::TWO))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::KING))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::SPADES, Cribbage::CardNames::KING))
    score = Cribbage::Scoring.score_pairs(hand)
    expect(score).to eq 4
  end

  it "can score a hand properly for pairs (3 of a kind)" do
    hand = Cribbage::CribHand.new
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::TWO))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::SPADES, Cribbage::CardNames::TWO))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::CLUBS, Cribbage::CardNames::TWO))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::DIAMONDS, Cribbage::CardNames::KING))
    score = Cribbage::Scoring.score_pairs(hand)
    expect(score).to eq 6
  end

  it "can score a hand properly for pairs (4 of a kind)" do
    hand = Cribbage::CribHand.new
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::TWO))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::SPADES, Cribbage::CardNames::TWO))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::CLUBS, Cribbage::CardNames::TWO))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::DIAMONDS, Cribbage::CardNames::TWO))
    score = Cribbage::Scoring.score_pairs(hand)
    expect(score).to eq 12
  end

  it "can score a hand properly for pairs (3 of a kind) w/ cut card" do
    hand = Cribbage::CribHand.new
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::TWO))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::SPADES, Cribbage::CardNames::TWO))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::CLUBS, Cribbage::CardNames::TWO))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::DIAMONDS, Cribbage::CardNames::KING))
    hand.cut_card = Cribbage::Card.new(Cribbage::Suits::DIAMONDS, Cribbage::CardNames::TWO)
    score = Cribbage::Scoring.score_pairs(hand)
    expect(score).to eq 12
  end

  it "can score nobs properly" do
    hand = Cribbage::CribHand.new
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::JACK))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::SPADES, Cribbage::CardNames::JACK))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::QUEEN))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::SIX))
    hand.cut_card = Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::FOUR)

    score = Cribbage::Scoring.score_nobs(hand)
    expect(score).to eq 1
  end

  it "doesn't score nobs when hand is crib" do
    hand = Cribbage::CribHand.new
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::JACK))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::SPADES, Cribbage::CardNames::JACK))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::QUEEN))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::SIX))
    hand.cut_card = Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::FOUR)
    hand.is_crib = true
    score = Cribbage::Scoring.score_nobs(hand)
    expect(score).to eq 0
  end

  it "doesn't score nobs when hand doesn't have a cut card" do
    hand = Cribbage::CribHand.new
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::JACK))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::SPADES, Cribbage::CardNames::JACK))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::QUEEN))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::SIX))
    score = Cribbage::Scoring.score_nobs(hand)
    expect(score).to eq 0
  end

  it "scores a flush (not a crib) does not match cut card" do
    hand = Cribbage::CribHand.new
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::JACK))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::EIGHT))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::QUEEN))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::SIX))
    hand.cut_card = Cribbage::Card.new(Cribbage::Suits::SPADES, Cribbage::CardNames::FOUR)
    score = Cribbage::Scoring.score_flush(hand)
    expect(score).to eq 4
  end

  it "scores a flush (not a crib) matches cut card" do
    hand = Cribbage::CribHand.new
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::JACK))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::EIGHT))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::QUEEN))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::SIX))
    hand.cut_card = Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::FOUR)
    score = Cribbage::Scoring.score_flush(hand)
    expect(score).to eq 5
  end

  it "scores a flush (is a crib) does not match cut card" do
    hand = Cribbage::CribHand.new
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::JACK))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::EIGHT))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::QUEEN))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::SIX))
    hand.cut_card = Cribbage::Card.new(Cribbage::Suits::SPADES, Cribbage::CardNames::FOUR)
    hand.is_crib = true
    score = Cribbage::Scoring.score_flush(hand)
    expect(score).to eq 0
  end

  it "scores a flush (is a crib) matches cut card" do
    hand = Cribbage::CribHand.new
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::JACK))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::EIGHT))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::QUEEN))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::SIX))
    hand.cut_card = Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::FOUR)
    hand.is_crib = true
    score = Cribbage::Scoring.score_flush(hand)
    expect(score).to eq 5
  end

  it "scores a 3-card run properly" do
    hand = Cribbage::CribHand.new
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::TWO))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::SPADES, Cribbage::CardNames::THREE))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::SPADES, Cribbage::CardNames::FOUR))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::DIAMONDS, Cribbage::CardNames::JACK))
    hand.cut_card = Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::NINE)
    hand.is_crib = true
    score = Cribbage::Scoring.score_runs(hand)
    expect(score).to eq 3
  end

  it "scores a 4-card run properly" do
    hand = Cribbage::CribHand.new
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::TWO))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::SPADES, Cribbage::CardNames::THREE))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::SPADES, Cribbage::CardNames::FOUR))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::DIAMONDS, Cribbage::CardNames::FIVE))
    hand.cut_card = Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::NINE)
    hand.is_crib = true
    score = Cribbage::Scoring.score_runs(hand)
    expect(score).to eq 4
  end

  it "scores a 5-card run properly" do
    hand = Cribbage::CribHand.new
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::TWO))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::SPADES, Cribbage::CardNames::THREE))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::SPADES, Cribbage::CardNames::FOUR))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::DIAMONDS, Cribbage::CardNames::FIVE))
    hand.cut_card = Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::SIX)
    hand.is_crib = true
    score = Cribbage::Scoring.score_runs(hand)
    expect(score).to eq 5
  end

  it "scores a double 3-card run properly" do
    hand = Cribbage::CribHand.new
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::SPADES, Cribbage::CardNames::TWO))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::THREE))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::SPADES, Cribbage::CardNames::FOUR))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::DIAMONDS, Cribbage::CardNames::TWO))
    hand.cut_card = Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::NINE)
    hand.is_crib = true
    score = Cribbage::Scoring.score_runs(hand)
    expect(score).to eq 6 # Two runs
  end

  it "scores a triple 3-card run properly" do
    hand = Cribbage::CribHand.new
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::SPADES, Cribbage::CardNames::TWO))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::SPADES, Cribbage::CardNames::THREE))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::FOUR))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::DIAMONDS, Cribbage::CardNames::TWO))
    hand.cut_card = Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::TWO)
    hand.is_crib = true
    score = Cribbage::Scoring.score_runs(hand)
    expect(score).to eq 9 # 3 separate runs (9 points)
  end

  it "scores a double-double 3-card run properly" do
    hand = Cribbage::CribHand.new
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::TWO))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::SPADES, Cribbage::CardNames::THREE))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::SPADES, Cribbage::CardNames::THREE))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::DIAMONDS, Cribbage::CardNames::FOUR))
    hand.cut_card = Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::FOUR)
    hand.is_crib = true
    score = Cribbage::Scoring.score_runs(hand)
    expect(score).to eq 12 # 4 separate runs of 3 (12 points)
  end

  it "scores fifteens properly (single fifteen)" do
    hand = Cribbage::CribHand.new
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::SEVEN))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::SPADES, Cribbage::CardNames::EIGHT))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::SPADES, Cribbage::CardNames::SIX))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::DIAMONDS, Cribbage::CardNames::FOUR))
    hand.cut_card = Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::TEN)
    hand.is_crib = true
    score = Cribbage::Scoring.score_fifteens(hand)
    expect(score).to eq 2
  end

  it "scores fifteens properly (multiple fifteens) kings/queens/fives" do
    hand = Cribbage::CribHand.new
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::FIVE))
    hand.cut_card = Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::TEN)
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::SPADES, Cribbage::CardNames::QUEEN))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::SPADES, Cribbage::CardNames::KING))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::DIAMONDS, Cribbage::CardNames::NINE))
    hand.is_crib = true
    score = Cribbage::Scoring.score_fifteens(hand)
    expect(score).to eq 6
  end

  it "scores fifteens properly (multiple fifteens)" do
    hand = Cribbage::CribHand.new
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::SEVEN))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::SPADES, Cribbage::CardNames::EIGHT))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::SPADES, Cribbage::CardNames::SIX))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::DIAMONDS, Cribbage::CardNames::NINE))
    hand.cut_card = Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::TEN)
    hand.is_crib = true
    score = Cribbage::Scoring.score_fifteens(hand)
    expect(score).to eq 4
  end

  it "scores fifteens properly (three card fifteen)" do
    hand = Cribbage::CribHand.new
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::TWO))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::SPADES, Cribbage::CardNames::NINE))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::SPADES, Cribbage::CardNames::QUEEN))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::DIAMONDS, Cribbage::CardNames::FOUR))
    hand.cut_card = Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::KING)
    hand.is_crib = true
    score = Cribbage::Scoring.score_fifteens(hand)
    expect(score).to eq 2
  end

  it "scores fifteens properly (three 5s)" do
    hand = Cribbage::CribHand.new
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::FIVE))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::SPADES, Cribbage::CardNames::FIVE))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::CLUBS, Cribbage::CardNames::FIVE))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::DIAMONDS, Cribbage::CardNames::TWO))
    hand.cut_card = Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::TWO)
    hand.is_crib = true
    score = Cribbage::Scoring.score_fifteens(hand)
    expect(score).to eq 2
  end

  it "scores fifteens properly (four card fifteen)" do
    hand = Cribbage::CribHand.new
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::THREE))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::SPADES, Cribbage::CardNames::THREE))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::SPADES, Cribbage::CardNames::FIVE))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::DIAMONDS, Cribbage::CardNames::FOUR))
    hand.cut_card = Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::ACE)
    hand.is_crib = true
    score = Cribbage::Scoring.score_fifteens(hand)
    expect(score).to eq 2
  end

  it "scores four fives properly" do
    hand = Cribbage::CribHand.new
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::FIVE))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::SPADES, Cribbage::CardNames::FIVE))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::CLUBS, Cribbage::CardNames::FIVE))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::DIAMONDS, Cribbage::CardNames::FIVE))
    hand.cut_card = Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::ACE)
    hand.is_crib = true
    score = Cribbage::Scoring.score_fifteens(hand)
    expect(score).to eq 8
  end

  it "scores four fives w/ jack properly" do
    hand = Cribbage::CribHand.new
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::FIVE))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::SPADES, Cribbage::CardNames::FIVE))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::CLUBS, Cribbage::CardNames::FIVE))
    hand.add_card(Cribbage::Card.new(Cribbage::Suits::DIAMONDS, Cribbage::CardNames::FIVE))
    hand.cut_card = Cribbage::Card.new(Cribbage::Suits::HEARTS, Cribbage::CardNames::JACK)
    hand.is_crib = true
    score = Cribbage::Scoring.score_fifteens(hand)
    expect(score).to eq 16
  end
end
