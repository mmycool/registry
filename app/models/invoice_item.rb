class InvoiceItem < ActiveRecord::Base
  include Versions
  belongs_to :invoice

  def amount
    price * quantity
  end
end
