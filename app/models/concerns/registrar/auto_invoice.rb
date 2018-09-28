module Concerns::Registrar::AutoInvoice
  extend ActiveSupport::Concern

  included do
    validates :auto_invoice_low_balance_threshold, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
    validates :auto_invoice_top_up_amount, numericality:
      { greater_than_or_equal_to: proc { |registrar| registrar.class.min_top_up_amount } }, allow_nil: true
    validates_presence_of :auto_invoice_low_balance_threshold,
                          :auto_invoice_top_up_amount,
                          :auto_invoice_iban, if: :auto_invoice_activated?
    validate :validate_auto_invoice_iban

    before_save :normalize_auto_invoice_iban
    composed_of :auto_invoice_iban, allow_nil: true, converter: proc { |value| IBAN.new(value) },
                class_name: 'IBAN', mapping: %w(auto_invoice_iban to_s)
  end

  class_methods do
    def registrars_eligible_to_auto_invoice
      all.select { |registrar| registrar.eligible_to_auto_invoice? }
    end

    def min_top_up_amount
      BigDecimal(Setting.minimum_deposit.to_s)
    end
  end

  def eligible_to_auto_invoice?
    auto_invoice_activated? && low_balance?(auto_invoice_low_balance_threshold) &&
      has_unpaid_automatically_generated_invoices?
  end

  private

  def validate_auto_invoice_iban
    return unless auto_invoice_iban
    errors.add(:auto_invoice_iban, :invalid) if auto_invoice_iban.invalid?
  end

  def normalize_auto_invoice_iban
    return if auto_invoice_iban.blank?
    self[:auto_invoice_iban] = auto_invoice_iban.normalize
  end

  def has_unpaid_automatically_generated_invoices?
    invoices.unpaid_automatically_generated.any?
  end

  def low_balance?(threshold)
    balance <= threshold
  end
end