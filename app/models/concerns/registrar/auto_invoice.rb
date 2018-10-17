module Concerns::Registrar::AutoInvoice
  extend ActiveSupport::Concern

  included do
    validates :auto_invoice_low_balance_threshold, numericality: { greater_than_or_equal_to: 0 },
              allow_nil: true
    validates :auto_invoice_top_up_amount, numericality:
      { greater_than_or_equal_to: proc { |registrar| registrar.class.min_top_up_amount } },
              allow_nil: true
    validates_presence_of :auto_invoice_low_balance_threshold,
                          :auto_invoice_top_up_amount,
                          :auto_invoice_iban, if: :auto_invoice_activated?

    before_save :normalize_auto_invoice_iban
  end

  class_methods do
    def min_top_up_amount
      BigDecimal(Setting.minimum_deposit.to_s)
    end
  end

  private

  def normalize_auto_invoice_iban
    return if auto_invoice_iban.blank?
    self[:auto_invoice_iban] = auto_invoice_iban.gsub(/\s+/, '').upcase
  end
end
