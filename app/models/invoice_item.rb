class InvoiceItem < ActiveRecord::Base
  belongs_to :invoice

  validates :description, presence: true
  validates :quantity, presence: true

  def item_sum_without_vat
    (quantity * price).round(2)
  end
end
