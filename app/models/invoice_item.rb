class InvoiceItem < ActiveRecord::Base
  include Versions
  belongs_to :invoice

  validates :vat_amount, presence: true

  attribute :vat_rate, ::Types::VATRate.new

  def amount
    price * quantity
  end

  def total
    amount + vat_amount
  end
end
