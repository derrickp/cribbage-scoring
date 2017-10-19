require "spec_helper"

RSpec.describe Cribbage do
  it "has a version number" do
    expect(Cribbage::VERSION).not_to be nil
  end
end

RSpec.describe Cribbage::Scoring do
  it "can score a hand properly for pairs (1 pair)" do
    hand = Cribbage::Hand.new
    hand.add_card(Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::TWO))
    hand.add_card(Cards::Card.new(Cards::Suits::SPADES, Cards::Names::TWO))
    hand.add_card(Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::NINE))
    hand.add_card(Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::KING))
    score = Cribbage::Scoring.score_pairs(hand)
    expect(score).to eq 2
  end

  it "can score a hand properly for pairs (2 pairs)" do
    hand = Cribbage::Hand.new
    hand.add_card(Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::TWO))
    hand.add_card(Cards::Card.new(Cards::Suits::SPADES, Cards::Names::TWO))
    hand.add_card(Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::KING))
    hand.add_card(Cards::Card.new(Cards::Suits::SPADES, Cards::Names::KING))
    score = Cribbage::Scoring.score_pairs(hand)
    expect(score).to eq 4
  end

  it "can score a hand properly for pairs (3 of a kind)" do
    hand = Cribbage::Hand.new
    hand.add_card(Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::TWO))
    hand.add_card(Cards::Card.new(Cards::Suits::SPADES, Cards::Names::TWO))
    hand.add_card(Cards::Card.new(Cards::Suits::CLUBS, Cards::Names::TWO))
    hand.add_card(Cards::Card.new(Cards::Suits::DIAMONDS, Cards::Names::KING))
    score = Cribbage::Scoring.score_pairs(hand)
    expect(score).to eq 6
  end

  it "can score a hand properly for pairs (4 of a kind)" do
    hand = Cribbage::Hand.new
    hand.add_card(Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::TWO))
    hand.add_card(Cards::Card.new(Cards::Suits::SPADES, Cards::Names::TWO))
    hand.add_card(Cards::Card.new(Cards::Suits::CLUBS, Cards::Names::TWO))
    hand.add_card(Cards::Card.new(Cards::Suits::DIAMONDS, Cards::Names::TWO))
    score = Cribbage::Scoring.score_pairs(hand)
    expect(score).to eq 12
  end

  it "can score a hand properly for pairs (3 of a kind) w/ cut card" do
    hand = Cribbage::Hand.new
    hand.add_card(Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::TWO))
    hand.add_card(Cards::Card.new(Cards::Suits::SPADES, Cards::Names::TWO))
    hand.add_card(Cards::Card.new(Cards::Suits::CLUBS, Cards::Names::TWO))
    hand.add_card(Cards::Card.new(Cards::Suits::DIAMONDS, Cards::Names::KING))
    hand.cut_card = Cards::Card.new(Cards::Suits::DIAMONDS, Cards::Names::TWO)
    score = Cribbage::Scoring.score_pairs(hand)
    expect(score).to eq 12
  end

  it "can score nobs properly" do
    hand = Cribbage::Hand.new
    hand.add_card(Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::JACK))
    hand.add_card(Cards::Card.new(Cards::Suits::SPADES, Cards::Names::JACK))
    hand.add_card(Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::QUEEN))
    hand.add_card(Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::SIX))
    hand.cut_card = Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::FOUR)

    score = Cribbage::Scoring.score_nobs(hand)
    expect(score).to eq 1
  end

  it "doesn't score nobs when hand is crib" do
    hand = Cribbage::Hand.new
    hand.add_card(Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::JACK))
    hand.add_card(Cards::Card.new(Cards::Suits::SPADES, Cards::Names::JACK))
    hand.add_card(Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::QUEEN))
    hand.add_card(Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::SIX))
    hand.cut_card = Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::FOUR)
    hand.is_crib = true
    score = Cribbage::Scoring.score_nobs(hand)
    expect(score).to eq 0
  end

  it "doesn't score nobs when hand doesn't have a cut card" do
    hand = Cribbage::Hand.new
    hand.add_card(Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::JACK))
    hand.add_card(Cards::Card.new(Cards::Suits::SPADES, Cards::Names::JACK))
    hand.add_card(Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::QUEEN))
    hand.add_card(Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::SIX))
    score = Cribbage::Scoring.score_nobs(hand)
    expect(score).to eq 0
  end

  it "scores a flush (not a crib) does not match cut card" do
    hand = Cribbage::Hand.new
    hand.add_card(Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::JACK))
    hand.add_card(Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::EIGHT))
    hand.add_card(Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::QUEEN))
    hand.add_card(Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::SIX))
    hand.cut_card = Cards::Card.new(Cards::Suits::SPADES, Cards::Names::FOUR)
    score = Cribbage::Scoring.score_flush(hand)
    expect(score).to eq 4
  end

  it "scores a flush (not a crib) matches cut card" do
    hand = Cribbage::Hand.new
    hand.add_card(Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::JACK))
    hand.add_card(Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::EIGHT))
    hand.add_card(Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::QUEEN))
    hand.add_card(Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::SIX))
    hand.cut_card = Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::FOUR)
    score = Cribbage::Scoring.score_flush(hand)
    expect(score).to eq 5
  end

  it "scores a flush (is a crib) does not match cut card" do
    hand = Cribbage::Hand.new
    hand.add_card(Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::JACK))
    hand.add_card(Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::EIGHT))
    hand.add_card(Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::QUEEN))
    hand.add_card(Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::SIX))
    hand.cut_card = Cards::Card.new(Cards::Suits::SPADES, Cards::Names::FOUR)
    hand.is_crib = true
    score = Cribbage::Scoring.score_flush(hand)
    expect(score).to eq 0
  end

  it "scores a flush (is a crib) matches cut card" do
    hand = Cribbage::Hand.new
    hand.add_card(Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::JACK))
    hand.add_card(Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::EIGHT))
    hand.add_card(Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::QUEEN))
    hand.add_card(Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::SIX))
    hand.cut_card = Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::FOUR)
    hand.is_crib = true
    score = Cribbage::Scoring.score_flush(hand)
    expect(score).to eq 5
  end

  it "scores a 3-card run properly" do
    hand = Cribbage::Hand.new
    hand.add_card(Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::TWO))
    hand.add_card(Cards::Card.new(Cards::Suits::SPADES, Cards::Names::THREE))
    hand.add_card(Cards::Card.new(Cards::Suits::SPADES, Cards::Names::FOUR))
    hand.add_card(Cards::Card.new(Cards::Suits::DIAMONDS, Cards::Names::JACK))
    hand.cut_card = Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::NINE)
    hand.is_crib = true
    score = Cribbage::Scoring.score_runs(hand)
    expect(score).to eq 3
  end

  it "scores a 4-card run properly" do
    hand = Cribbage::Hand.new
    hand.add_card(Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::TWO))
    hand.add_card(Cards::Card.new(Cards::Suits::SPADES, Cards::Names::THREE))
    hand.add_card(Cards::Card.new(Cards::Suits::SPADES, Cards::Names::FOUR))
    hand.add_card(Cards::Card.new(Cards::Suits::DIAMONDS, Cards::Names::FIVE))
    hand.cut_card = Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::NINE)
    hand.is_crib = true
    score = Cribbage::Scoring.score_runs(hand)
    expect(score).to eq 4
  end

  it "scores a 5-card run properly" do
    hand = Cribbage::Hand.new
    hand.add_card(Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::TWO))
    hand.add_card(Cards::Card.new(Cards::Suits::SPADES, Cards::Names::THREE))
    hand.add_card(Cards::Card.new(Cards::Suits::SPADES, Cards::Names::FOUR))
    hand.add_card(Cards::Card.new(Cards::Suits::DIAMONDS, Cards::Names::FIVE))
    hand.cut_card = Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::SIX)
    hand.is_crib = true
    score = Cribbage::Scoring.score_runs(hand)
    expect(score).to eq 5
  end

  it "scores a double 3-card run properly" do
    hand = Cribbage::Hand.new
    hand.add_card(Cards::Card.new(Cards::Suits::SPADES, Cards::Names::TWO))
    hand.add_card(Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::THREE))
    hand.add_card(Cards::Card.new(Cards::Suits::SPADES, Cards::Names::FOUR))
    hand.add_card(Cards::Card.new(Cards::Suits::DIAMONDS, Cards::Names::TWO))
    hand.cut_card = Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::NINE)
    hand.is_crib = true
    score = Cribbage::Scoring.score_runs(hand)
    expect(score).to eq 6 # Two runs
  end

  it "scores a triple 3-card run properly" do
    hand = Cribbage::Hand.new
    hand.add_card(Cards::Card.new(Cards::Suits::SPADES, Cards::Names::TWO))
    hand.add_card(Cards::Card.new(Cards::Suits::SPADES, Cards::Names::THREE))
    hand.add_card(Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::FOUR))
    hand.add_card(Cards::Card.new(Cards::Suits::DIAMONDS, Cards::Names::TWO))
    hand.cut_card = Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::TWO)
    hand.is_crib = true
    score = Cribbage::Scoring.score_runs(hand)
    expect(score).to eq 9 # 3 separate runs (9 points)
  end

  it "scores a double-double 3-card run properly" do
    hand = Cribbage::Hand.new
    hand.add_card(Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::TWO))
    hand.add_card(Cards::Card.new(Cards::Suits::SPADES, Cards::Names::THREE))
    hand.add_card(Cards::Card.new(Cards::Suits::SPADES, Cards::Names::THREE))
    hand.add_card(Cards::Card.new(Cards::Suits::DIAMONDS, Cards::Names::FOUR))
    hand.cut_card = Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::FOUR)
    hand.is_crib = true
    score = Cribbage::Scoring.score_runs(hand)
    expect(score).to eq 12 # 4 separate runs of 3 (12 points)
  end

  it "scores fifteens properly (single fifteen)" do
    hand = Cribbage::Hand.new
    hand.add_card(Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::SEVEN))
    hand.add_card(Cards::Card.new(Cards::Suits::SPADES, Cards::Names::EIGHT))
    hand.add_card(Cards::Card.new(Cards::Suits::SPADES, Cards::Names::SIX))
    hand.add_card(Cards::Card.new(Cards::Suits::DIAMONDS, Cards::Names::FOUR))
    hand.cut_card = Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::TEN)
    hand.is_crib = true
    score = Cribbage::Scoring.score_fifteens(hand)
    expect(score).to eq 2
  end

  it "scores fifteens properly (multiple fifteens) kings/queens/fives" do
    hand = Cribbage::Hand.new
    hand.add_card(Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::FIVE))
    hand.cut_card = Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::TEN)
    hand.add_card(Cards::Card.new(Cards::Suits::SPADES, Cards::Names::QUEEN))
    hand.add_card(Cards::Card.new(Cards::Suits::SPADES, Cards::Names::KING))
    hand.add_card(Cards::Card.new(Cards::Suits::DIAMONDS, Cards::Names::NINE))
    hand.is_crib = true
    score = Cribbage::Scoring.score_fifteens(hand)
    expect(score).to eq 6
  end

  it "scores fifteens properly (multiple fifteens)" do
    hand = Cribbage::Hand.new
    hand.add_card(Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::SEVEN))
    hand.add_card(Cards::Card.new(Cards::Suits::SPADES, Cards::Names::EIGHT))
    hand.add_card(Cards::Card.new(Cards::Suits::SPADES, Cards::Names::SIX))
    hand.add_card(Cards::Card.new(Cards::Suits::DIAMONDS, Cards::Names::NINE))
    hand.cut_card = Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::TEN)
    hand.is_crib = true
    score = Cribbage::Scoring.score_fifteens(hand)
    expect(score).to eq 4
  end

  it "scores fifteens properly (three card fifteen)" do
    hand = Cribbage::Hand.new
    hand.add_card(Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::TWO))
    hand.add_card(Cards::Card.new(Cards::Suits::SPADES, Cards::Names::NINE))
    hand.add_card(Cards::Card.new(Cards::Suits::SPADES, Cards::Names::QUEEN))
    hand.add_card(Cards::Card.new(Cards::Suits::DIAMONDS, Cards::Names::FOUR))
    hand.cut_card = Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::KING)
    hand.is_crib = true
    score = Cribbage::Scoring.score_fifteens(hand)
    expect(score).to eq 2
  end

  it "scores fifteens properly (three 5s)" do
    hand = Cribbage::Hand.new
    hand.add_card(Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::FIVE))
    hand.add_card(Cards::Card.new(Cards::Suits::SPADES, Cards::Names::FIVE))
    hand.add_card(Cards::Card.new(Cards::Suits::CLUBS, Cards::Names::FIVE))
    hand.add_card(Cards::Card.new(Cards::Suits::DIAMONDS, Cards::Names::TWO))
    hand.cut_card = Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::TWO)
    hand.is_crib = true
    score = Cribbage::Scoring.score_fifteens(hand)
    expect(score).to eq 2
  end

  it "scores fifteens properly (four card fifteen)" do
    hand = Cribbage::Hand.new
    hand.add_card(Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::THREE))
    hand.add_card(Cards::Card.new(Cards::Suits::SPADES, Cards::Names::THREE))
    hand.add_card(Cards::Card.new(Cards::Suits::SPADES, Cards::Names::FIVE))
    hand.add_card(Cards::Card.new(Cards::Suits::DIAMONDS, Cards::Names::FOUR))
    hand.cut_card = Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::ACE)
    hand.is_crib = true
    score = Cribbage::Scoring.score_fifteens(hand)
    expect(score).to eq 2
  end

  it "scores four fives properly" do
    hand = Cribbage::Hand.new
    hand.add_card(Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::FIVE))
    hand.add_card(Cards::Card.new(Cards::Suits::SPADES, Cards::Names::FIVE))
    hand.add_card(Cards::Card.new(Cards::Suits::CLUBS, Cards::Names::FIVE))
    hand.add_card(Cards::Card.new(Cards::Suits::DIAMONDS, Cards::Names::FIVE))
    hand.cut_card = Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::ACE)
    hand.is_crib = true
    score = Cribbage::Scoring.score_fifteens(hand)
    expect(score).to eq 8
  end

  it "scores four fives w/ jack properly" do
    hand = Cribbage::Hand.new
    hand.add_card(Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::FIVE))
    hand.add_card(Cards::Card.new(Cards::Suits::SPADES, Cards::Names::FIVE))
    hand.add_card(Cards::Card.new(Cards::Suits::CLUBS, Cards::Names::FIVE))
    hand.add_card(Cards::Card.new(Cards::Suits::DIAMONDS, Cards::Names::FIVE))
    hand.cut_card = Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::JACK)
    hand.is_crib = true
    score = Cribbage::Scoring.score_fifteens(hand)
    expect(score).to eq 16
  end

  it "scores four fives w/ jack properly (best hand)" do
    hand = Cribbage::Hand.new
    hand.add_card(Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::JACK))
    hand.add_card(Cards::Card.new(Cards::Suits::SPADES, Cards::Names::FIVE))
    hand.add_card(Cards::Card.new(Cards::Suits::CLUBS, Cards::Names::FIVE))
    hand.add_card(Cards::Card.new(Cards::Suits::DIAMONDS, Cards::Names::FIVE))
    hand.cut_card = Cards::Card.new(Cards::Suits::HEARTS, Cards::Names::FIVE)
    score = Cribbage::Scoring.score_hand(hand)
    expect(score).to eq 29
  end
end
