# frozen_string_literal: true

require 'spec_helper'

module Cribbage
  RSpec.describe Cribbage do
    it 'has a version number' do
      expect(VERSION).not_to be nil
    end
  end
end
