require 'test_helper'

class InvoiceItemTest < ActiveSupport::TestCase
  def test_calculate_item_sum_without_vat
    item = InvoiceItem.new(price: 5, quantity: 2)
    assert_equal 10, item.item_sum_without_vat
  end
end