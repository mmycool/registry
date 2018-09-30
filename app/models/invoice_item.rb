class InvoiceItem < ActiveRecord::Base
  include Versions
  belongs_to :invoice

  delegate :vat_rate, to: :invoice

  def amount
    price * quantity
  end

  def vat_amount
    amount * vat_rate
  end

  def total
    amount + vat_amount
  end
end
