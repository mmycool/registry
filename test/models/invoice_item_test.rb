require 'test_helper'

class InvoiceItemTest < ActiveSupport::TestCase
  def setup
    @item = invoice_items(:valid)
  end

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

  def test_requires_unit
    item = InvoiceItem.new(unit: nil)
    item.validate
    assert item.errors.added?(:unit, :blank)
  end

  def test_calculates_amount
    assert_equal 10, @item.amount
  end
end
