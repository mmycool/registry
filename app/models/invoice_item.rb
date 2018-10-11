class InvoiceItem < ActiveRecord::Base
  include Versions
  belongs_to :invoice

  attribute :vat_rate, ::Types::VATRate.new

  def amount
    price * quantity
  end
end
