class InvoiceItem < ActiveRecord::Base
  belongs_to :invoice

  def item_sum_without_vat
    (quantity * price).round(2)
  end
end
