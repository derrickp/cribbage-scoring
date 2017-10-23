# frozen_string_literal: true

require 'spec_helper'
require_relative '../support/card_helper'

module Cribbage
  RSpec.describe DoubleScore do
    let(:hand) do
      Hand.new.tap do |hand|
        cards.each { |card| hand.add_card(card) }
        hand.cut_card = cut_card
        hand.is_crib = is_crib
      end
    end

    describe 'fifteens' do
      let(:is_crib) { false }
      subject { DoubleScore.new(hand) }

      context 'single fifteen' do
        let(:cards) do
          create_cards('7H 8S 6S 4D')
        end
        let(:cut_card) { create_card('TH') }

        it 'should score 4' do
          expect(subject.fifteens).to eq 4
        end
      end

      context 'multiple fifteens (kings/queens/fives)' do
        let(:cards) do
          create_cards('5H TH QS KS')
        end
        let(:cut_card) { create_card('9D') }

        it 'should score 12' do
          expect(subject.fifteens).to eq 12
        end
      end

      context 'multiple fifteens' do
        let(:cards) do
          create_cards('7H 8S 6S 9D')
        end
        let(:cut_card) { create_card('TH') }

        it 'should score 8' do
          expect(subject.fifteens).to eq 8
        end
      end

      context 'three card fifteen' do
        let(:cards) do
          create_cards('2H 9S QS 4D')
        end
        let(:cut_card) { create_card('KH') }

        it 'should score 4' do
          expect(subject.fifteens).to eq 4
        end
      end

      context 'three 5s' do
        let(:cards) do
          create_cards('5H 5S 5C 2D')
        end
        let(:cut_card) { create_card('2H') }

        it 'should score 4' do
          expect(subject.fifteens).to eq 4
        end
      end

      context 'four card fifteen' do
        let(:cards) do
          create_cards('3H 3S 5S 4D')
        end
        let(:cut_card) { create_card('AH') }

        it 'should score 4' do
          expect(subject.fifteens).to eq 4
        end
      end

      context 'four fives' do
        let(:cards) do
          create_cards('5H 5S 5C 5D')
        end
        let(:cut_card) { create_card('AH') }

        it 'should score 16' do
          expect(subject.fifteens).to eq 16
        end
      end

      context 'four fives w/ jack' do
        let(:cards) do
          create_cards('5H 5S 5C 5D')
        end
        let(:cut_card) { create_card('JH') }

        it 'should be 32' do
          expect(subject.fifteens).to eq 32
        end
      end
    end
  end
end
