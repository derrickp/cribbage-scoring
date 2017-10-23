# frozen_string_literal: true

require 'spec_helper'
require_relative '../support/card_helper'

module Cribbage
  RSpec.describe BasicScore do
    let(:hand) do
      Hand.new.tap do |hand|
        cards.each { |card| hand.add_card(card) }
        hand.cut_card = cut_card
        hand.is_crib = is_crib
      end
    end

    describe 'fifteens' do
      let(:is_crib) { false }
      subject { BasicScore.new(hand) }

      context 'single fifteen' do
        let(:cards) do
          create_cards('7H 8S 6S 4D')
        end
        let(:cut_card) { create_card('TH') }

        it 'should score 2' do
          expect(subject.fifteens).to eq 2
        end
      end

      context 'multiple fifteens (kings/queens/fives)' do
        let(:cards) do
          create_cards('5H TH QS KS')
        end
        let(:cut_card) { create_card('9D') }

        it 'should score 6' do
          expect(subject.fifteens).to eq 6
        end
      end

      context 'multiple fifteens' do
        let(:cards) do
          create_cards('7H 8S 6S 9D')
        end
        let(:cut_card) { create_card('TH') }

        it 'should score 4' do
          expect(subject.fifteens).to eq 4
        end
      end

      context 'three card fifteen' do
        let(:cards) do
          create_cards('2H 9S QS 4D')
        end
        let(:cut_card) { create_card('KH') }

        it 'should score 2' do
          expect(subject.fifteens).to eq 2
        end
      end

      context 'three 5s' do
        let(:cards) do
          create_cards('5H 5S 5C 2D')
        end
        let(:cut_card) { create_card('2H') }

        it 'should score 2' do
          expect(subject.fifteens).to eq 2
        end
      end

      context 'four card fifteen' do
        let(:cards) do
          create_cards('3H 3S 5S 4D')
        end
        let(:cut_card) { create_card('AH') }

        it 'should score 2' do
          expect(subject.fifteens).to eq 2
        end
      end

      context 'four fives' do
        let(:cards) do
          create_cards('5H 5S 5C 5D')
        end
        let(:cut_card) { create_card('AH') }

        it 'should score 8' do
          expect(subject.fifteens).to eq 8
        end
      end

      context 'four fives w/ jack' do
        let(:cards) do
          create_cards('5H 5S 5C 5D')
        end
        let(:cut_card) { create_card('JH') }

        it 'should be 16' do
          expect(subject.fifteens).to eq 16
        end
      end
    end

    describe 'pairs' do
      subject { BasicScore.new(hand) }
      let(:is_crib) { false }
      context '1 pair' do
        let(:cards) do
          create_cards('2H 2S 9H KH')
        end
        let(:cut_card) { create_card('5C') }

        it 'should score 2' do
          expect(subject.pairs).to eq 2
        end
      end

      context '2 pairs' do
        let(:cards) do
          create_cards('2H 2S KH KS')
        end
        let(:cut_card) { create_card('5C') }

        it 'should score 4' do
          expect(subject.pairs).to eq 4
        end
      end

      context '3 of a kind' do
        let(:cards) do
          create_cards('2H 2S 2C KD')
        end
        let(:cut_card) { create_card('5C') }

        it 'should score 6' do
          expect(subject.pairs).to eq 6
        end
      end

      context '4 of a kind' do
        let(:cards) do
          create_cards('2H 2S 2C 2D')
        end
        let(:cut_card) { create_card('5C') }

        it 'should score 12' do
          expect(subject.pairs).to eq 12
        end
      end

      context '3 of a kind w/ cut card' do
        let(:cards) do
          create_cards('2H 2S 2C KD')
        end
        let(:cut_card) { create_card('2D') }

        it 'should score 12' do
          expect(subject.pairs).to eq 12
        end
      end
    end

    describe 'nobs' do
      subject { BasicScore.new(hand) }
      let(:cards) do
        create_cards('JH JS QH 6H')
      end
      let(:cut_card) { create_card('4H') }

      context 'hand is not crib' do
        let(:is_crib) { false }

        it 'should score 1' do
          expect(subject.nobs).to eq 1
        end
      end

      context 'hand is crib' do
        let(:is_crib) { true }

        it 'should score 0' do
          expect(subject.nobs).to eq 0
        end
      end

      context 'no cut card' do
        let(:is_crib) { false }
        let(:cut_card) { nil }

        it 'should score 0' do
          expect(subject.nobs).to eq 0
        end
      end
    end

    describe 'flushes' do
      subject { BasicScore.new(hand) }
      describe 'hand is a flush' do
        let(:cards) do
          create_cards('JH 8H QH 6H')
        end

        context 'is not a crib' do
          let(:is_crib) { false }

          context 'does not match cut card' do
            let(:cut_card) { create_card('4S') }

            it 'should score 4' do
              expect(subject.flushes).to eq 4
            end
          end

          context 'does match cut card' do
            let(:cut_card) { create_card('4H') }

            it 'should score 5' do
              expect(subject.flushes).to eq 5
            end
          end
        end

        context 'is a crib' do
          let(:is_crib) { true }

          context 'does not match cut card' do
            let(:cut_card) { create_card('4S') }

            it 'should score 0' do
              expect(subject.flushes).to eq 0
            end
          end

          context 'matches cut card' do
            let(:cut_card) { create_card('4H') }

            it 'should score 5' do
              expect(subject.flushes).to eq 5
            end
          end
        end
      end
    end

    describe 'runs' do
      subject { BasicScore.new(hand) }
      let(:is_crib) { true }
      let(:cut_card) { create_card('9H') }

      context '3-card run' do
        let(:cards) do
          create_cards('2H 3S 4S JD')
        end

        it 'should score 3' do
          expect(subject.runs).to eq 3
        end
      end

      context '4-card run' do
        let(:cards) do
          create_cards('2H 3S 4S 5D')
        end

        it 'should score 4' do
          expect(subject.runs).to eq 4
        end
      end

      context '5-card run' do
        let(:cards) do
          create_cards('2H 3S 4S 5D')
        end
        let(:cut_card) { create_card('6H') }

        it 'should score 5' do
          expect(subject.runs).to eq 5
        end
      end

      context 'double 3-card run' do
        let(:cards) do
          create_cards('2S 3H 4S 2D')
        end

        it 'should score 6' do
          expect(subject.runs).to eq 6
        end
      end

      context 'triple 3-card run' do
        let(:cards) do
          create_cards('2S 3S 4H 2D')
        end
        let(:cut_card) { create_card('2H') }

        it 'should score 9' do
          expect(subject.runs).to eq 9
        end
      end

      context 'double-double 3-card run' do
        let(:cards) do
          create_cards('2H 3S 3C 4D')
        end
        let(:cut_card) { create_card('4H') }

        it 'should score 12' do
          expect(subject.runs).to eq 12
        end
      end
    end

    describe 'total' do
      subject { BasicScore.new(hand) }
      let(:is_crib) { false }

      context 'four fives w/ proper jack (best hand)' do
        let(:cards) do
          create_cards('JH 5S 5C 5D')
        end
        let(:cut_card) { create_card('5H') }

        it 'should score 29' do
          expect(subject.total).to eq 29
        end
      end

      context 'single run, 3 fifteens' do
        let(:cards) do
          create_cards('JH QS KC 5D')
        end
        let(:cut_card) { create_card('9D') }

        it 'should score 9' do
          expect(subject.total).to eq 9
        end
      end

      context 'single run, 2 fifteens, no nobs because of crib' do
        let(:is_crib) { true }
        let(:cards) do
          create_cards('JH 9S TC 5D')
        end
        let(:cut_card) { create_card('4H') }

        it 'should score 7' do
          expect(subject.total).to eq 7
        end
      end
    end
  end
end
