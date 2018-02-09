class Deck
  def initialize(cards)
    @cards = cards.compact
  end

  def deal_out(hand_one, hand_two)
    @cards.shuffle!
    52.times do |i|
      hand_one.add(@cards[i]) if i % 2 == 1
      hand_two.add(@cards[i]) if i % 2 == 0
    end
  end
end
