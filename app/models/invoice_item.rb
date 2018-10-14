class InvoiceItem < ActiveRecord::Base
  include Versions
  belongs_to :invoice

  validates :vat_amount, presence: true

  def amount
    price * quantity
  end

  def total
    amount + vat_amount
  end
end
