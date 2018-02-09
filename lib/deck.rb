class Deck
  def initialize(cards)
    @cards = cards
  end

  def deal_out(hand_one, hand_two)
    @cards.shuffle!
    @cards.each_with_index do |card, i|
      hand_one.add(card) if i % 2 == 1
      hand_two.add(card) if i % 2 == 0
    end
  end
end
