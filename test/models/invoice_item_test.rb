require 'test_helper'

class InvoiceItemTest < ActiveSupport::TestCase
  def test_requires_description
    item = InvoiceItem.new(description: nil)
    item.validate
    assert item.errors.added?(:description, :blank)
  end

  def test_requires_quantity
    item = InvoiceItem.new(quantity: nil)
    item.validate
    assert item.errors.added?(:quantity, :blank)
  end
end
