require 'minitest/autorun'
require_relative '../lib/deck'
require_relative '../lib/player_hand'

describe Deck do
  describe 'deal_out' do
    it 'passes every other card between two hands' do
      deck = Deck.new(['some card', 'some other card', 'still another card', 'a fourth card'])
      some_player = PlayerHand.new
      another_player = PlayerHand.new

      deck.deal_out(some_player, another_player)

      assert_equal(some_player.cards.count, 2)
      assert_equal(another_player.cards.count, 2)
    end
  end
end
