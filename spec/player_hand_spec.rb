require_relative 'test_helper'

require_relative '../lib/player_hand'

describe PlayerHand do
  before do
    @player_hand = PlayerHand.new
  end

  describe 'add' do
    it "moves a card into the player hand's cards" do
      @player_hand.add('some card')
      assert_includes(@player_hand.cards, 'some card')
    end
  end

  describe 'has_cards?' do
    it 'returns true if there are cards in the player hand' do
      @player_hand.add('some card')
      assert(@player_hand.has_cards?)
    end

    it 'returns false if there are no cards in the player hand' do
      refute(@player_hand.has_cards?)
    end
  end

  describe 'current_card' do
    before do
      @player_hand.add('some other card')
      @player_hand.add('some card')
    end

    it 'sets the last card as the current card if there is not one already' do
      assert_equal(@player_hand.current_card, 'some card')
    end

    it 'reuses the same card if it is not passed' do
      assert_equal(@player_hand.current_card, 'some card')
      assert_equal(@player_hand.current_card, 'some card')
    end

    it 'moves to the next card if the current card is lost' do
      assert_equal(@player_hand.current_card, 'some card')
      @player_hand.cards.pop
      assert_equal(@player_hand.current_card, 'some other card')
    end
  end

  describe 'claim' do
    it 'adds a card that was won to the front of the hand' do
      @player_hand.add('original card')
      @player_hand.claim("my opponent's card")
      assert_equal(@player_hand.cards.first, "my opponent's card")
      assert_equal(@player_hand.cards.last, 'original card')
    end
  end

  describe 'pass_current_card' do
    it 'removes the current card from the hand' do
      @player_hand.add('another card')
      @player_hand.add('some card')
      passed = @player_hand.pass_current_card
      assert_equal(@player_hand.current_card, 'another card')
      assert_equal(passed, 'some card')
    end
  end
end
