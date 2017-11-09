require 'test_helper'

class InvoiceItemTest < ActiveSupport::TestCase
  def test_requires_quantity
    item = InvoiceItem.new(quantity: nil)
    item.validate
    assert item.errors.added?(:quantity, :blank)
  end
end
