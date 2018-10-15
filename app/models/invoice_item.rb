class InvoiceItem < ActiveRecord::Base
  include Versions
  belongs_to :invoice

  before_create :persist_calculated_total

  def amount
    price * quantity
  end

  def total
    calculate_total
  end

  private

  def calculate_total
    amount + vat_amount
  end

  def persist_calculated_total
    self.total = calculate_total
  end
end
