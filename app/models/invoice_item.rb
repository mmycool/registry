class InvoiceItem < ActiveRecord::Base
  include Versions
  belongs_to :invoice

  def amount
    (price * quantity).round(2)
  end
end
