require 'minitest/autorun'
require_relative '../lib/card'

describe Card do
  it 'remembers a value' do
    card = Card.new('some value')
    assert_equal(card.value, 'some value')
  end
end
