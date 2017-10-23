# frozen_string_literal: true

require 'spec_helper'

module Cards
  RSpec.describe Deck do
    context 'basic deck' do
      before(:each) do
        @deck = Deck.new
      end

      it 'has 52 cards' do
        expect(@deck.cards.length).to eq 52
      end

      it 'can draw a card' do
        card = @deck.draw
        expect(card).not_to be nil
        expect(card.class).to eq Card
      end

      it 'never draws the same card twice' do
        cards = []
        52.times do
          card = @deck.draw
          expect(cards.include?(card)).to eq false
          cards << card
        end
        expect(cards.length).to eq 52
        expect(@deck.cards.length).to eq 0
      end

      it 'can be reset' do
        52.times do
          @deck.draw
        end
        expect(@deck.cards.length).to eq 0 # Shouldn't be any cards in the deck if we've drawn 52
        @deck.reset
        expect(@deck.cards.length).to eq 52 # We've reset the deck, should be 52 again
      end
    end
  end
end
