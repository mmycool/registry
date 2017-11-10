class InvoiceItem < ActiveRecord::Base
  belongs_to :invoice

  validates :description, presence: true
  validates :quantity, presence: true
  validates :unit, presence: true
  validates :price, presence: true

  def amount
    quantity * price
  end
end
