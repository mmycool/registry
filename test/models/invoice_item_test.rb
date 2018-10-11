require 'test_helper'

class InvoiceItemTest < ActiveSupport::TestCase
  def test_calculates_amount
    item = InvoiceItem.new(price: 5, quantity: 2)
    assert_equal 10, item.amount
  end
end
