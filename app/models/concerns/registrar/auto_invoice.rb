module Concerns::Registrar::AutoInvoice
  extend ActiveSupport::Concern

  included do
    monetize :low_balance_threshold_cents, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
    monetize :top_up_amount_cents, numericality: { greater_than: 0 }, allow_nil: true
  end

  class_methods do
    def invoice_registrars_with_low_balance
      Registrar.all.each do |registrar|
        registrar.issue_prepayment_invoice(registrar.top_up_amount)
        yield registrar, registrar.top_up_amount
      end
    end
  end
end