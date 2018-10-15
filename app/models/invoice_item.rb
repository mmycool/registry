class InvoiceItem < ActiveRecord::Base
  include Versions
  belongs_to :invoice

  before_create :persist_calculated_vat_amount
  before_create :persist_calculated_total

  def amount
    price * quantity
  end

  def vat_amount
    calculate_vat_amount
  end

  def total
    calculate_total
  end

  private

  def vat_rate
    invoice.vat_rate
  end

  def calculate_vat_amount
    vat_rate.vat_amount(amount)
  end

  def persist_calculated_vat_amount
    self.vat_amount = calculate_vat_amount
  end

  def calculate_total
    amount + vat_amount
  end

  def persist_calculated_total
    self.total = calculate_total
  end
end
